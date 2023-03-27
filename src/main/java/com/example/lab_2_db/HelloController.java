package com.example.lab_2_db;

import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.ForeignKeyInfo;
import com.example.lab_2_db.model.Role;
import com.example.lab_2_db.model.TableInfo;
import com.example.lab_2_db.model.UserInfo;
import com.example.lab_2_db.visualizers.*;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import lombok.NoArgsConstructor;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

@NoArgsConstructor
public class HelloController implements Initializable {
    @FXML
    private Button showPermissions;
    @FXML
    private TableView<Role> userRoles;
    @FXML
    private TableView<Role> availableRoles;
    @FXML
    private Button deleteUser;
    @FXML
    private Button deleteRole;
    @FXML
    private Button createUser;
    @FXML
    private TextField password;
    @FXML
    private TextField username;
    private DatabaseManager databaseManager;
    private TableContentVisualizer tableContentVisualizer;
    private UsersVisualizers usersVisualizers;
    private RolesVisualizers rolesVisualizers;
    @FXML
    private TableView<UserInfo> users;
    @FXML
    public Button updateRow;
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

    @FXML
    private TableView<ForeignKeyInfo> foreignKeyInfo;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        initDB();
        initUsers();
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
        TableInfo selectedTableInfo = tablesInfo.getSelectionModel().getSelectedItem();
        tableContentVisualizer = new TableContentVisualizer(databaseManager);
        tableContent.setItems(tableContentVisualizer.getTableContent(selectedTableInfo, tableContent).getItems());
        initForeignKeyInfo(selectedTableInfo.getName());
    }

    @FXML
    void deleteContentTableRow() {
        tableContentVisualizer.deleteSelectedRow(tableContent, tablesInfo.getSelectionModel().getSelectedItem());
    }

    @FXML
    public void addRow() throws SQLException {
        tableContentVisualizer.addRow(tableContent, tablesInfo.getSelectionModel().getSelectedItem());
    }

    @FXML
    public void updateRow() {
        tableContentVisualizer.updateTable(tableContent, tablesInfo.getSelectionModel().getSelectedItem());
    }

    public void initForeignKeyInfo(String selectedTable) {
        ForeignKeyVisualizer foreignKeyVisualizer = new ForeignKeyVisualizer(databaseManager);
        TableView<ForeignKeyInfo> foreignKeyInfo1 =
            foreignKeyVisualizer.showForeignKeyInfo(foreignKeyInfo, selectedTable);
        foreignKeyInfo.setItems(foreignKeyInfo1.getItems());
    }

    public void getUserRoles() {
        rolesVisualizers = new RolesVisualizers(databaseManager);
        TableView<Role> rolesFromDb = rolesVisualizers.getUserRolesTableView(users, userRoles);
        userRoles.setItems(rolesFromDb.getItems());

        getAvailableUserRoles();
    }

    public void getAvailableUserRoles() {
        TableView<Role> availableToAssigneeRolesFromDb =
            rolesVisualizers.getAvailableToAssigneeRoles(availableRoles, users.getSelectionModel().getSelectedItem());
        availableRoles.setItems(availableToAssigneeRolesFromDb.getItems());
    }

    public void initUsers() {
        usersVisualizers = new UsersVisualizers(databaseManager);
        TableView<UserInfo> usersFromDb = usersVisualizers.getUsers(users);
        users.setItems(usersFromDb.getItems());
    }

    @FXML
    public void createUser() {
        usersVisualizers.createUser(username.getText(), password.getText());
        username.clear();
        password.clear();
        initUsers();
    }

    @FXML
    public void deleteUser() {
        usersVisualizers.deleteUser(users.getSelectionModel().getSelectedItem());
        initUsers();
    }

    public void deleteRole() {
        rolesVisualizers.deleteRole(userRoles.getSelectionModel().getSelectedItem(), users.getSelectionModel().getSelectedItem());
        getAvailableUserRoles();
        getUserRoles();
    }

    public void addRole() {
        rolesVisualizers.addRole(availableRoles.getSelectionModel().getSelectedItem(),
            users.getSelectionModel().getSelectedItem());
        getAvailableUserRoles();
        getUserRoles();
    }

}
