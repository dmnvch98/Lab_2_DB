package com.example.lab_2_db.visualizers;

import com.example.lab_2_db.alerts.ErrorAlert;
import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.ForeignKeyInfo;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.SQLException;

@Data
@AllArgsConstructor
public class ForeignKeyVisualizer {
    private final DatabaseManager databaseManager;

    public TableView<ForeignKeyInfo> showForeignKeyInfo(TableView<ForeignKeyInfo> foreignKeyTable, String tableName) {
        foreignKeyTable.getColumns().clear();
        ObservableList<ForeignKeyInfo> foreignKeyData = null;
        try {
            foreignKeyData = FXCollections.observableArrayList(databaseManager.getForeignKeyInfos(tableName));
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error getting foreign keys: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
        foreignKeyTable.setItems(foreignKeyData);
        foreignKeyTable.setEditable(false);

        TableColumn<ForeignKeyInfo, String> constraintNameColumn = new TableColumn<>("Constraint Name");
        constraintNameColumn.setCellValueFactory(new PropertyValueFactory<>("constraintName"));
        TableColumn<ForeignKeyInfo, String> columnNameColumn = new TableColumn<>("Column Name");
        columnNameColumn.setCellValueFactory(new PropertyValueFactory<>("columnName"));
        TableColumn<ForeignKeyInfo, String> referencedTableNameColumn = new TableColumn<>("Referenced Table Name");
        referencedTableNameColumn.setCellValueFactory(new PropertyValueFactory<>("referencedTableName"));
        TableColumn<ForeignKeyInfo, String> referencedColumnNameColumn = new TableColumn<>("Referenced Column Name");
        referencedColumnNameColumn.setCellValueFactory(new PropertyValueFactory<>("referencedColumnName"));
        foreignKeyTable.getColumns().addAll(constraintNameColumn, columnNameColumn, referencedTableNameColumn, referencedColumnNameColumn);
        return foreignKeyTable;
    }
}
