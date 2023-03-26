package com.example.lab_2_db.visualizers;

import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.ForeignKeyInfo;
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

@Data
@AllArgsConstructor
public class UsersVisualizers {
    private final DatabaseManager databaseManager;
    public static final String request = "SELECT USER FROM mysql.user;";

    public TableView<UserInfo> getUsers(TableView<UserInfo> users) {
        try {
            ResultSet rs = databaseManager.executeQuery(request);
            ObservableList<UserInfo> usernames = FXCollections.observableArrayList();
            while (rs.next()) {
                String username = rs.getString("USER");
                UserInfo userInfo = UserInfo.builder().username(username).build();
                usernames.add(userInfo);
            }
            users.setItems(usernames);
            users.setEditable(false);

            TableColumn<UserInfo, String> userColumn = new TableColumn<>("User");
            userColumn.setCellValueFactory(new PropertyValueFactory<>("Username"));

            users.getColumns().addAll(userColumn);

            return users;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
