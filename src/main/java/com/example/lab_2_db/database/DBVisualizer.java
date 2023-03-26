package com.example.lab_2_db.database;

import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@Data
@AllArgsConstructor
public class DBVisualizer {
    public DBVisualizer(DatabaseManager databaseManager) {
        this.databaseManager = databaseManager;
    }

    private final DatabaseManager databaseManager;
    private List<TableInfo> tableInfos = new ArrayList<>();
    private List<ForeignKeyInfo> foreignKeyInfos = new ArrayList<>();
    private TableView<TableInfo> tableTable = new TableView<>();

    public void showTables() {
        try {
            showTablesInfo();

            ObservableList<ForeignKeyInfo> foreignKeyData = FXCollections.observableArrayList(foreignKeyInfos);
            TableView<ForeignKeyInfo> foreignKeyTable = new TableView<>();
            foreignKeyTable.setItems(foreignKeyData);
            foreignKeyTable.setEditable(false);

            TableColumn<ForeignKeyInfo, String> constraintNameColumn = new TableColumn<>("Constraint Name");
            constraintNameColumn.setCellValueFactory(new PropertyValueFactory<>("constraintName"));
            TableColumn<ForeignKeyInfo, String> tableNameColumn = new TableColumn<>("Table Name");
            tableNameColumn.setCellValueFactory(new PropertyValueFactory<>("tableName"));
            TableColumn<ForeignKeyInfo, String> columnNameColumn = new TableColumn<>("Column Name");
            columnNameColumn.setCellValueFactory(new PropertyValueFactory<>("columnName"));
            TableColumn<ForeignKeyInfo, String> referencedTableNameColumn = new TableColumn<>("Referenced Table Name");
            referencedTableNameColumn.setCellValueFactory(new PropertyValueFactory<>("referencedTableName"));
            TableColumn<ForeignKeyInfo, String> referencedColumnNameColumn = new TableColumn<>("Referenced Column Name");
            referencedColumnNameColumn.setCellValueFactory(new PropertyValueFactory<>("referencedColumnName"));
            foreignKeyTable.getColumns().addAll(constraintNameColumn, tableNameColumn, columnNameColumn, referencedTableNameColumn, referencedColumnNameColumn);

            TableView<ObservableList<String>> tableView = new TableView<>();
            tableView.setEditable(true);

            HBox hBox = new HBox(5);
            Button showButton = new Button("Show Table Contents");
            showButton.setOnAction(event -> {
                TableInfo selectedTableInfo = tableTable.getSelectionModel().getSelectedItem();
                if (selectedTableInfo == null) {
                    return;
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

                    Alert getTableInfoAlert = new Alert(Alert.AlertType.INFORMATION);
                    getTableInfoAlert.setTitle("Update Successful");
                    getTableInfoAlert.setContentText("Rows get: " + count + "\nExecution time: " + executionTime + " ms");
                    getTableInfoAlert.showAndWait();

                    tableView.setItems(data);
                    tableView.getColumns().clear();
                    for (int i = 1; i <= metaData.getColumnCount(); i++) {
                        final int colNo = i - 1;
                        TableColumn<ObservableList<String>, String> column = new TableColumn<>(metaData.getColumnName(i));
                        column.setCellValueFactory(param -> new SimpleObjectProperty<>(param.getValue().get(colNo)));
                        column.setCellFactory(TextFieldTableCell.forTableColumn());
                        column.setOnEditCommit(eventEdit -> {
                            String newValue = eventEdit.getNewValue();
                            ObservableList<String> rowValue = eventEdit.getTableView().getItems().get(eventEdit.getTablePosition().getRow());
                            String oldValue = rowValue.get(colNo);
                            if (!newValue.equals(oldValue)) {
                                try {
                                    String updateQuery = "UPDATE " + selectedTableInfo.getName() + " SET " + metaData.getColumnName(colNo + 1) + "='" + newValue + "' WHERE ";
                                    for (int j = 1; j <= metaData.getColumnCount(); j++) {
                                        if (j != colNo + 1) {
                                            updateQuery += metaData.getColumnName(j) + "='" + rowValue.get(j - 1) + "' AND ";
                                        }
                                    }
                                    updateQuery = updateQuery.substring(0, updateQuery.length() - 5);
                                    long startTime = System.currentTimeMillis();
                                    int rowsUpdated = databaseManager.executeUpdate(updateQuery);
                                    long endTime = System.currentTimeMillis();
                                    executionTime.set(endTime - startTime);

                                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                                    alert.setTitle("Update Successful");
                                    alert.setContentText("Rows updated: " + rowsUpdated + "\nExecution time: " + executionTime + " ms");
                                    alert.showAndWait();
                                } catch (SQLException e) {
                                    System.out.println("Error updating value in database: " + e.getMessage());
                                }
                            }
                            rowValue.set(colNo, newValue);
                        });
                        tableView.getColumns().add(column);
                    }
                } catch (SQLException e) {
                    Alert alert = new Alert(Alert.AlertType.ERROR);
                    alert.setTitle("Error executing query");
                    alert.setContentText(e.getMessage());
                    alert.showAndWait();
                }
            });

            VBox vBox = new VBox(5);
            vBox.getChildren().addAll(tableTable, showButton, tableView, foreignKeyTable);

            BorderPane borderPane = new BorderPane(vBox);
            Scene scene = new Scene(borderPane, 1200, 1000);

            Stage stage = new Stage();
            stage.setScene(scene);
            stage.setTitle("Database Visualizer");
            stage.show();
        } catch (SQLException e) {
            System.out.println("Error getting table or foreign key info: " + e.getMessage());
//            Utils.showErrorAlert("Error getting table or foreign key info: " + e.getMessage());
        }
    }
    private void showTablesInfo() throws SQLException {
        tableInfos = databaseManager.getTableInfos();
        foreignKeyInfos = tableInfos
            .stream()
            .map(tableInfo -> {
                try {
                    return databaseManager
                        .getForeignKeyInfos(tableInfo.getName());
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }).flatMap(List::stream)
            .toList();

        ObservableList<TableInfo> tableData = FXCollections.observableArrayList(tableInfos);
        tableTable = new TableView<>();
        tableTable.setItems(tableData);
        tableTable.setEditable(false);

        TableColumn<TableInfo, String> nameColumn = new TableColumn<>("Table Name");
        nameColumn.setCellValueFactory(new PropertyValueFactory<>("name"));
        TableColumn<TableInfo, String> engineColumn = new TableColumn<>("Engine");
        engineColumn.setCellValueFactory(new PropertyValueFactory<>("engine"));
        tableTable.getColumns().addAll(nameColumn, engineColumn);
    }
}

