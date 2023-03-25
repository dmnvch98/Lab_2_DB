package com.example.lab_2_db.database;

import com.example.lab_2_db.Utils;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.lang.reflect.Field;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

@Data
@AllArgsConstructor
public class DBVIz<T> {
    private DatabaseManager databaseManager;
    private Class<T> tableClass;

    public void showTable(String tableName) throws SQLException {
        ResultSet rs = databaseManager.executeQuery("SELECT * FROM " + tableName);

        TableView<T> table = new TableView<>();
        table.setEditable(false);

        // Add columns to table
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnName(i);
            TableColumn<T, Object> col = new TableColumn<>(columnName);
            String fieldName = Utils.snakeCaseToCamelCase(columnName);
            col.setCellValueFactory(new PropertyValueFactory<>(fieldName));
            table.getColumns().add(col);
        }

        // Add data to table
        while (rs.next()) {
            T obj;
            try {
                obj = tableClass.newInstance();
            } catch (InstantiationException | IllegalAccessException e) {
                throw new RuntimeException("Cannot create instance of table class", e);
            }
            Field[] fields = tableClass.getDeclaredFields();
            for (Field field : fields) {
                String columnName = Utils.camelCaseToSnakeCase(field.getName());
                try {
                    field.setAccessible(true);
                    if (field.getType() == Integer.TYPE) {
                        field.set(obj, rs.getInt(columnName));
                    } else if (field.getType() == String.class) {
                        field.set(obj, rs.getString(columnName));
                    } else if (field.getType() == Long.TYPE) {
                        field.set(obj, rs.getLong(columnName));
                    } else if (field.getType() == Double.TYPE) {
                        field.set(obj, rs.getDouble(columnName));
                    } else if (field.getType() == Float.TYPE) {
                        field.set(obj, rs.getFloat(columnName));
                    } else if (field.getType() == Boolean.TYPE) {
                        field.set(obj, rs.getBoolean(columnName));
                    }
                } catch (IllegalAccessException e) {
                    throw new RuntimeException("Cannot set value for field " + field.getName(), e);
                }
            }
            table.getItems().add(obj);
        }

        // Create stage to show table
        Stage stage = new Stage();
        stage.setTitle(tableName);

        VBox vbox = new VBox();
        vbox.getChildren().add(table);

        Scene scene = new Scene(vbox);
        stage.setScene(scene);

        Button button = new Button("Show Table Contents");
        button.setOnAction(e -> {
            VBox vbox1 = new VBox();
            vbox1.getChildren().add(table);
            Scene scene1 = new Scene(vbox1);
            Stage stage1 = new Stage();
            stage1.setScene(scene1);
            stage1.show();
        });
        vbox.getChildren().add(button);

        stage.show();
    }
}
