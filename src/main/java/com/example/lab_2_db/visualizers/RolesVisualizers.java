package com.example.lab_2_db.visualizers;

import com.example.lab_2_db.alerts.ErrorAlert;
import com.example.lab_2_db.alerts.InfoAlert;
import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.RoleInfo;
import com.example.lab_2_db.model.UserInfo;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Data
@RequiredArgsConstructor
public class RolesVisualizers {
    public RolesVisualizers(DatabaseManager databaseManager) {
        this.databaseManager = databaseManager;
    }

    private DatabaseManager databaseManager;

    private final List<RoleInfo> ROLES = Arrays.asList(
        RoleInfo.builder().description("ALL").build(),
        RoleInfo.builder().description("CREATE").build(),
        RoleInfo.builder().description("DELETE").build(),
        RoleInfo.builder().description("DROP").build(),
        RoleInfo.builder().description("EXECUTE").build(),
        RoleInfo.builder().description("GRANT OPTION").build(),
        RoleInfo.builder().description("INSERT").build(),
        RoleInfo.builder().description("SELECT").build(),
        RoleInfo.builder().description("SHOW DATABASES").build(),
        RoleInfo.builder().description("UPDATE").build()
    );

    public TableView<RoleInfo> getUserRolesTableView(TableView<UserInfo> users, TableView<RoleInfo> rolesTableView) {
        rolesTableView.getColumns().clear();
        UserInfo userInfo = users.getSelectionModel().getSelectedItem();
        ObservableList<RoleInfo> rolesObservableList =
            FXCollections.observableArrayList(getListOfUserRoles(userInfo.getUsername()));
        rolesTableView.setItems(rolesObservableList);

        TableColumn<RoleInfo, String> rolesColumn = new TableColumn<>("User Roles");
        rolesColumn.setCellValueFactory(new PropertyValueFactory<>("Description"));

        rolesTableView.getColumns().addAll(rolesColumn);

        return rolesTableView;
    }

    private static List<String> extractRolesFromGrant(String grant) {
        List<String> roles = new ArrayList<>();

        Pattern pattern = Pattern.compile("^GRANT\\s+(.*?)\\s+ON\\s+");
        Matcher matcher = pattern.matcher(grant);

        if (matcher.find()) {
            String[] tokens = matcher.group(1).split(",");
            for (String token : tokens) {
                roles.add(token.trim());
            }
        }

        return roles;
    }

    private List<RoleInfo> getListOfUserRoles(String username) {
        try {
            String request = "SHOW GRANTS FOR '" + username + "'@'localhost'";
            ResultSet rs = databaseManager.executeQuery(request);
            List<String> grants = new ArrayList<>();

            while (rs.next()) {
                grants.add(rs.getString(1));
            }
            return grants
                .stream()
                .map(RolesVisualizers::extractRolesFromGrant)
                .flatMap(Collection::stream)
                .map(role -> RoleInfo.builder().description(role).build())
                .toList();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while getting roles: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
        return null;
    }

    public TableView<RoleInfo> getAvailableToAssigneeRoles(TableView<RoleInfo> tableView, UserInfo userInfo) {
        tableView.getColumns().clear();
        List<RoleInfo> availableToAssigneeRolesList = ROLES.stream()
            .filter(role -> !Objects.requireNonNull(getListOfUserRoles(userInfo.getUsername())).contains(role))
            .toList();
        ObservableList<RoleInfo> availableToAssigneeRolesObservableList =
            FXCollections.observableArrayList(availableToAssigneeRolesList);
        tableView.setItems(availableToAssigneeRolesObservableList);

        TableColumn<RoleInfo, String> rolesColumn = new TableColumn<>("Available to assignee roles");
        rolesColumn.setCellValueFactory(new PropertyValueFactory<>("Description"));

        tableView.getColumns().addAll(rolesColumn);

        return tableView;
    }

    public void deleteRole(RoleInfo role, UserInfo userInfo) {
        try {
            String request = "REVOKE " + role.getDescription() + " ON mysql.* FROM ' " + userInfo.getUsername() + "'@'localhost';";
            long startTime = System.currentTimeMillis();
            databaseManager.executeUpdate(request);
            long endTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(endTime - startTime);
            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("Role " + role.getDescription() + " is deleted from user: " + userInfo.getUsername()
                    + " \nExecution time: " + executionTime + " ms")
                .build();
            infoAlert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while deleting " + role.getDescription() + " role : " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
    }

    public void addRole(RoleInfo role, UserInfo userInfo) {
        try {
            String request = "GRANT " + role.getDescription() + " ON mysql.* TO ' " + userInfo.getUsername() + "'@'localhost';";
            long startTime = System.currentTimeMillis();
            databaseManager.executeUpdate(request);
            long endTime = System.currentTimeMillis();
            AtomicLong executionTime = new AtomicLong(endTime - startTime);
            InfoAlert infoAlert = InfoAlert
                .builder()
                .message("Role " + role.getDescription() + " is added to user: " + userInfo.getUsername()
                    + " \nExecution time: " + executionTime + " ms")                .build();
            infoAlert.showAlert();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while adding " + role.getDescription() + " role : " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
    }
}

