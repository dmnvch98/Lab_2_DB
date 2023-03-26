package com.example.lab_2_db.database;

import com.example.lab_2_db.alerts.ErrorAlert;
import com.example.lab_2_db.alerts.InfoAlert;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.TextFieldTableCell;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicLong;

@Data
@AllArgsConstructor
public class TableContentVisualizer {
    public TableContentVisualizer(DatabaseManager databaseManager) {
        this.databaseManager = databaseManager;
    }

    private final DatabaseManager databaseManager;
    private ResultSetMetaData metaData;
    public TableView<ObservableList<String>> getTableContent(TableInfo selectedTableInfo, TableView<ObservableList<String>> tableView) {
        if (selectedTableInfo == null) {
            return null;
        }

        try {
            long getTableInfoStartTime = System.currentTimeMillis();
            ResultSet rs = databaseManager.executeQuery("SELECT * FROM " + selectedTableInfo.getName());
            long getTableInfoEndTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(getTableInfoEndTime - getTableInfoStartTime);

            metaData = rs.getMetaData();
            ObservableList<ObservableList<String>> data = FXCollections.observableArrayList();
            int count = 0;

            while (rs.next()) {
                count++;
                ObservableList<String> row = FXCollections.observableArrayList();
                for (int i = 1; i <= metaData.getColumnCount(); i++) {
                    row.add(rs.getString(i));
                }
                data.add(row);
            }

            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("Rows get: " + count + "\nExecution time: " + executionTime + " ms")
                .build();
            infoAlert.showAlert();

            tableView.setEditable(true);
            tableView.setItems(data);
            tableView.getColumns().clear();
            for (int i = 1; i <= metaData.getColumnCount(); i++) {
                final int colNo = i - 1;
                TableColumn<ObservableList<String>, String> column = new TableColumn<>(metaData.getColumnName(i));
                column.setCellValueFactory(param -> new SimpleObjectProperty<>(param.getValue().get(colNo)));
                column.setCellFactory(TextFieldTableCell.forTableColumn());
                column.setOnEditCommit(eventEdit -> updateTable(eventEdit, colNo, selectedTableInfo, metaData));
                tableView.getColumns().add(column);
            }
            // Пустая строка для вставки новой строки
            ObservableList<String> newRow = FXCollections.observableArrayList();
            for (int i = 0; i < metaData.getColumnCount(); i++) {
                newRow.add("");
            }
            tableView.getItems().add(newRow);

        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error executing query: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
        return tableView;
    }

    private void updateTable(TableColumn.CellEditEvent<ObservableList<String>, String> editEvent, int colNo,
                             TableInfo selectedTableInfo, ResultSetMetaData metaData) {
        if (editEvent.getNewValue() == null || editEvent.getNewValue().isEmpty()) {
            return;
        }
        String newValue = editEvent.getNewValue();

        ObservableList<String> rowValue = editEvent.getTableView().getItems().get(editEvent.getTablePosition().getRow());

        String oldValue = rowValue.get(colNo);
        String primaryKeyValue = rowValue.get(0);

        if (!newValue.equals(oldValue)) {
            try {
                String updateQuery = "UPDATE " + selectedTableInfo.getName() +
                    " SET " + metaData.getColumnName(colNo + 1) + "='" + newValue +
                    "' WHERE " + selectedTableInfo.getPrimaryKey() + " = " + primaryKeyValue;

                long startTime = System.currentTimeMillis();

                int rowsUpdated = databaseManager.executeUpdate(updateQuery);

                long endTime = System.currentTimeMillis();
                AtomicLong executionTime = new AtomicLong(endTime - startTime);

                InfoAlert updateAlert = InfoAlert
                    .builder()
                    .message("Rows updated: " + rowsUpdated + "\nExecution time: " + executionTime + " ms")
                    .build();
                updateAlert.showAlert();

            } catch (SQLException e) {
                ErrorAlert errorAlert = ErrorAlert
                    .builder()
                    .message("Error updating value in database: " + e.getMessage())
                    .build();
                errorAlert.showAlert();
            }
        }
        rowValue.set(colNo, newValue);
    }

    public void deleteSelectedRow(TableView<ObservableList<String>> tableView, TableInfo selectedTableInfo) {
        ObservableList<ObservableList<String>> selectedRows = tableView.getSelectionModel().getSelectedItems();
        if (selectedRows.isEmpty()) {
            return;
        }
        ObservableList<String> selectedRow = selectedRows.get(0);
        String primaryKeyValue = selectedRow.get(0);
        try {
            String deleteQuery = "DELETE FROM " + selectedTableInfo.getName() + " WHERE " + selectedTableInfo.getPrimaryKey() + " = '" + primaryKeyValue + "'";
            long startTime = System.currentTimeMillis();
            int rowsUpdated = databaseManager.executeUpdate(deleteQuery);
            long endTime = System.currentTimeMillis();
            tableView.getItems().remove(selectedRow);
            AtomicLong executionTime = new AtomicLong(endTime - startTime);

            InfoAlert alert = InfoAlert
                .builder()
                .message("Rows deleted: " + rowsUpdated + "\nExecution time: " + executionTime + " ms")
                .build();
            alert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error deleting row: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
    }

    public void addRow(TableView<ObservableList<String>> tableView, TableInfo selectedTableInfo) throws SQLException {
        ObservableList<String> lastRow = tableView.getItems().get(tableView.getItems().size() - 1);
        StringBuilder query = new StringBuilder("INSERT INTO " + selectedTableInfo.getName() + " VALUES (");
        for (int i = 0; i < metaData.getColumnCount(); i++) {
            String value = lastRow.get(i);
            query.append("'").append(value).append("'");
            if (i < metaData.getColumnCount() - 1) {
                query.append(",");
            }
        }
        query.append(")");
        try {
            long startTime = System.currentTimeMillis();
            int rowsInserted = databaseManager.executeUpdate(query.toString());
            long endTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(endTime - startTime);
            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("Rows inserted: " + rowsInserted + "\nExecution time: " + executionTime + " ms")
                .build();
            infoAlert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error inserting row: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }

    }

}
