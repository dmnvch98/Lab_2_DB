package com.example.lab_2_db;

import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.database.TableContentVisualizer;
import com.example.lab_2_db.database.TableInfo;
import com.example.lab_2_db.database.TableInfoVisuallizer;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableView;
import javafx.scene.input.MouseEvent;
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
    private DatabaseManager databaseManager;
    private TableContentVisualizer tableContentVisualizer;
    @FXML
    public Button addRow;
    @FXML
    private Button showTableContent;
    @FXML
    private Button deleteContentTableRow;
    @FXML
    private TableView<ObservableList<String>> tableContent;

    @FXML
    private TableView<TableInfo> tablesInfo;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        initDB();
        initTablesInfo();
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

        Connection connection;
        try {
            connection = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        databaseManager = new DatabaseManager(connection);
    }

    private void initTablesInfo() {
        TableInfoVisuallizer tableInfoVisuallizer = new TableInfoVisuallizer(databaseManager);
        TableView<TableInfo> tableView = tableInfoVisuallizer.getTablesInfo(tablesInfo);
        tablesInfo.setItems(tableView.getItems());
    }
    @FXML
    private void initTableContent() {
        tableContentVisualizer = new TableContentVisualizer(databaseManager);
        tableContent.setItems(tableContentVisualizer.getTableContent(tablesInfo.getSelectionModel().getSelectedItem(), tableContent).getItems());
    }

    @FXML
    void deleteContentTableRow() {
        tableContentVisualizer.deleteSelectedRow(tableContent, tablesInfo.getSelectionModel().getSelectedItem());
    }

    @FXML
    public void addRow() throws SQLException {
        tableContentVisualizer.addRow(tableContent, tablesInfo.getSelectionModel().getSelectedItem());
    }
}
