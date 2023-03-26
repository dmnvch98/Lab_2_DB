package com.example.lab_2_db.database;

import com.example.lab_2_db.alerts.ErrorAlert;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.SQLException;
import java.util.List;

@Data
@AllArgsConstructor
public class TableInfoVisuallizer {
    private final DatabaseManager databaseManager;

    public TableView<TableInfo> getTablesInfo(TableView<TableInfo> tableInfo) {
        List<TableInfo> tableInfos = null;
        try {
            tableInfos = databaseManager.getTableInfos();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error getting table or foreign key info: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }

        ObservableList<TableInfo> tableData = FXCollections.observableArrayList(tableInfos);
        tableInfo.setItems(tableData);
        tableInfo.setEditable(false);

        TableColumn<TableInfo, String> nameColumn = new TableColumn<>("Table Name");
        nameColumn.setCellValueFactory(new PropertyValueFactory<>("name"));

        TableColumn<TableInfo, String> engineColumn = new TableColumn<>("Engine");
        engineColumn.setCellValueFactory(new PropertyValueFactory<>("engine"));

        TableColumn<TableInfo, String> primaryKeyColumn = new TableColumn<>("Primary key");
        primaryKeyColumn.setCellValueFactory(new PropertyValueFactory<>("primaryKey"));

        tableInfo.getColumns().addAll(nameColumn, engineColumn, primaryKeyColumn);
        return tableInfo;
    }

}
