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
    private final DatabaseManager databaseManager;
    public TableView<ObservableList<String>> getTableContent(TableView<TableInfo> tableTable, TableView<ObservableList<String>> tableView) {
        TableInfo selectedTableInfo = tableTable.getSelectionModel().getSelectedItem();
        if (selectedTableInfo == null) {
            return null;
        }

        try {
            long getTableInfoStartTime = System.currentTimeMillis();
            ResultSet rs = databaseManager.executeQuery("SELECT * FROM " + selectedTableInfo.getName());
            long getTableInfoEndTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(getTableInfoEndTime - getTableInfoStartTime);

            ResultSetMetaData metaData = rs.getMetaData();
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
        String newValue = editEvent.getNewValue();
        ObservableList<String> rowValue = editEvent.getTableView().getItems().get(editEvent.getTablePosition().getRow());
        String oldValue = rowValue.get(colNo);
        if (!newValue.equals(oldValue)) {
            try {
                StringBuilder updateQuery = new StringBuilder("UPDATE " + selectedTableInfo.getName() + " SET " + metaData.getColumnName(colNo + 1) + "='" + newValue + "' WHERE ");
                for (int j = 1; j <= metaData.getColumnCount(); j++) {
                    if (j != colNo + 1) {
                        updateQuery.append(metaData.getColumnName(j)).append("='").append(rowValue.get(j - 1)).append("' AND ");
                    }
                }
                updateQuery = new StringBuilder(updateQuery.substring(0, updateQuery.length() - 5));

                long startTime = System.currentTimeMillis();

                int rowsUpdated = databaseManager.executeUpdate(updateQuery.toString());

                long endTime = System.currentTimeMillis();
                AtomicLong executionTime = new AtomicLong(endTime - startTime);

                InfoAlert updateAlert = InfoAlert
                    .builder()
                    .message("Rows get: " + rowsUpdated + "\nExecution time: " + executionTime + " ms")
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
}
