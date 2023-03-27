package com.example.lab_2_db.visualizers;

import com.example.lab_2_db.alerts.ErrorAlert;
import com.example.lab_2_db.alerts.InfoAlert;
import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.UserInfo;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicLong;

@Data
@AllArgsConstructor
public class UsersVisualizers {
    private final DatabaseManager databaseManager;
    public static final String request = "SELECT * FROM mysql.user;";
    public static final String CREATE_USER_REQUEST = "CREATE USER '?'@'localhost' IDENTIFIED BY '?';";

    public TableView<UserInfo> getUsers(TableView<UserInfo> users) {
        try {
            users.getColumns().clear();
            ResultSet rs = databaseManager.executeQuery(request);
            ObservableList<UserInfo> usernames = FXCollections.observableArrayList();
            while (rs.next()) {
                String username = rs.getString("USER");
                String accountLocked = rs.getString("account_locked");
                String passwordExpired = rs.getString("password_expired");
                UserInfo userInfo = UserInfo
                    .builder()
                    .username(username)
                    .accountLocked(accountLocked)
                    .passwordExpired(passwordExpired)
                    .build();
                usernames.add(userInfo);
            }
            users.setItems(usernames);
            users.setEditable(false);

            TableColumn<UserInfo, String> userColumn = new TableColumn<>("User");
            userColumn.setCellValueFactory(new PropertyValueFactory<>("Username"));

            TableColumn<UserInfo, String> accountLockedColumn = new TableColumn<>("Locked");
            accountLockedColumn.setCellValueFactory(new PropertyValueFactory<>("accountLocked"));

            TableColumn<UserInfo, String> passwordExpiredColumn = new TableColumn<>("Pass Expired");
            passwordExpiredColumn.setCellValueFactory(new PropertyValueFactory<>("passwordExpired"));

            users.getColumns().addAll(userColumn, accountLockedColumn, passwordExpiredColumn);

            return users;
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while getting users: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
        return users;
    }

    public void createUser(String username, String password) {
        try {
            String request = "CREATE USER '" + username +"'@'localhost' IDENTIFIED BY '" + password + "'";
            long startTime = System.currentTimeMillis();
            databaseManager.executeUpdate(request);
            long endTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(endTime - startTime);
            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("User is created\nExecution time: " + executionTime + " ms")
                .build();
            infoAlert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while getting the users: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
    }

    public void deleteUser(UserInfo userInfo) {
        try {
            long startTime = System.currentTimeMillis();
            String request = "DROP USER '" + userInfo.getUsername() +"'@'localhost';";
            databaseManager.executeUpdate(request);
            long endTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(endTime - startTime);
            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("User is deleted\nExecution time: " + executionTime + " ms")
                .build();
            infoAlert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while getting the users: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
    }
}
