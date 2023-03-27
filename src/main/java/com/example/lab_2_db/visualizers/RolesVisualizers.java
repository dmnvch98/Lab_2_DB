package com.example.lab_2_db.visualizers;

import com.example.lab_2_db.alerts.ErrorAlert;
import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.Role;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Data
@RequiredArgsConstructor
public class RolesVisualizers {
    public RolesVisualizers(DatabaseManager databaseManager) {
        this.databaseManager = databaseManager;
    }

    private DatabaseManager databaseManager;

    List<Role> roles = Arrays.asList(
        Role.builder().role("ALL").build(),
        Role.builder().role("CREATE").build(),
        Role.builder().role("DELETE").build(),
        Role.builder().role("DROP").build(),
        Role.builder().role("EXECUTE").build(),
        Role.builder().role("GRANT OPTION").build(),
        Role.builder().role("INSERT").build(),
        Role.builder().role("SELECT").build(),
        Role.builder().role("SHOW DATABASES").build(),
        Role.builder().role("UPDATE").build()
    );

    public TableView<Role> getUserRolesTableView(TableView<UserInfo> users, TableView<Role> rolesTableView) {
        rolesTableView.getColumns().clear();
        UserInfo userInfo = users.getSelectionModel().getSelectedItem();
        //            String request = "SHOW GRANTS FOR '" + userInfo.getUsername() + "'@'localhost'";
//            ResultSet rs = databaseManager.executeQuery(request);
//            List<String> grants = new ArrayList<>();
//
//            while (rs.next()) {
//                grants.add(rs.getString(1));
//            }
//            List<Role> rolesList = grants
//                .stream()
//                .map(RolesVisualizers::extractRolesFromGrant)
//                .flatMap(Collection::stream)
//                .map(role -> Role.builder().role(role).build())
//                .toList();

        ObservableList<Role> rolesObservableList =
            FXCollections.observableArrayList(getListOfUserRoles(userInfo.getUsername()));
        rolesTableView.setItems(rolesObservableList);

        TableColumn<Role, String> rolesColumn = new TableColumn<>("User Roles");
        rolesColumn.setCellValueFactory(new PropertyValueFactory<>("Role"));

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

    private List<Role> getListOfUserRoles(String username) {
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
                .map(role -> Role.builder().role(role).build())
                .toList();
        } catch (SQLException e) {
            ErrorAlert errorAlert = ErrorAlert
                .builder()
                .message("Error while getting users: " + e.getMessage())
                .build();
            errorAlert.showAlert();
        }
        return null;
    }

    public TableView<Role> getAvailableToAssigneeRoles(TableView<Role> tableView, UserInfo userInfo) {
        tableView.getColumns().clear();
        List<Role> availableToAssigneeRolesList = roles.stream()
            .filter(role -> !Objects.requireNonNull(getListOfUserRoles(userInfo.getUsername())).contains(role))
            .toList();
        ObservableList<Role> availableToAssigneeRolesObservableList =
            FXCollections.observableArrayList(availableToAssigneeRolesList);
        tableView.setItems(availableToAssigneeRolesObservableList);

        TableColumn<Role, String> rolesColumn = new TableColumn<>("Available to assignee roles");
        rolesColumn.setCellValueFactory(new PropertyValueFactory<>("Role"));

        tableView.getColumns().addAll(rolesColumn);

        return tableView;
    }
}

