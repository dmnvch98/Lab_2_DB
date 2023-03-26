package com.example.lab_2_db;

import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.database.TableInfo;
import com.example.lab_2_db.database.TableInfoVisuallizer;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableView;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

@Data
@NoArgsConstructor
public class HelloController implements Initializable {

    @FXML
    private Button showTableContent;

    @FXML
    private TableView<?> tableContent;

    @FXML
    private TableView<TableInfo> tableInfo;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        initDB();
    }

    private void initDB() {
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "Jeka31312565";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        Connection connection = null;
        try {
            connection = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        DatabaseManager databaseManager = new DatabaseManager(connection);

        TableInfoVisuallizer tableInfoVisuallizer = new TableInfoVisuallizer(databaseManager);
        TableView<TableInfo> tableView = tableInfoVisuallizer.getTablesInfo(tableInfo);
        tableInfo.setItems(tableView.getItems());
    }
}
