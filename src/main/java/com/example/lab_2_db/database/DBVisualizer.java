package com.example.lab_2_db.database;

import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
public class DBVisualizer {
    private final DatabaseManager databaseManager;

    public void showTables() {
        try {
            List<TableInfo> tableInfos = databaseManager.getTableInfos();
//            List<ForeignKeyInfo> foreignKeyInfos = databaseManager.getForeignKeyInfos();

            List<ForeignKeyInfo> foreignKeyInfos = tableInfos
                .stream()
                .map(tableInfo -> {
                    try {
                        return databaseManager
                            .getForeignKeyInfos(tableInfo.getName());
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).flatMap(List::stream)
                .collect(Collectors.toList());

            ObservableList<TableInfo> tableData = FXCollections.observableArrayList(tableInfos);
            TableView<TableInfo> tableTable = new TableView<>();
            tableTable.setItems(tableData);
            tableTable.setEditable(false);

            TableColumn<TableInfo, String> nameColumn = new TableColumn<>("Table Name");
            nameColumn.setCellValueFactory(new PropertyValueFactory<>("name"));
            TableColumn<TableInfo, String> engineColumn = new TableColumn<>("Engine");
            engineColumn.setCellValueFactory(new PropertyValueFactory<>("engine"));
            tableTable.getColumns().addAll(nameColumn, engineColumn);

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
            tableView.setEditable(false);

            HBox hBox = new HBox(5);
            Button showButton = new Button("Show Table Contents");
            showButton.setOnAction(event -> {
                TableInfo selectedTableInfo = tableTable.getSelectionModel().getSelectedItem();
                if (selectedTableInfo == null) {
                    return;
                }

                try {
                    ResultSet rs = databaseManager.executeQuery("SELECT * FROM " + selectedTableInfo.getName());
                    ResultSetMetaData metaData = rs.getMetaData();
                    ObservableList<ObservableList<String>> data = FXCollections.observableArrayList();
                    while (rs.next()) {
                        ObservableList<String> row = FXCollections.observableArrayList();
                        for (int i = 1; i <= metaData.getColumnCount(); i++) {
                            row.add(rs.getString(i));
                        }
                        data.add(row);
                    }

                    tableView.setItems(data);
                    tableView.getColumns().clear();
                    for (int i = 1; i <= metaData.getColumnCount(); i++) {
                        TableColumn<ObservableList<String>, String> column = new TableColumn<>(metaData.getColumnName(i));
                        final int colNo = i - 1;
                        column.setCellValueFactory(param -> new SimpleStringProperty(param.getValue().get(colNo)));
                        tableView.getColumns().add(column);
                    }
                } catch (SQLException e) {
                    System.out.println("Error executing query: " + e.getMessage());
//                    Utils.showErrorAlert("Error executing query: " + e.getMessage());
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
}

