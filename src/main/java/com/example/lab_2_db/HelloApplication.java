package com.example.lab_2_db;

import com.example.lab_2_db.database.DBVIz;
import com.example.lab_2_db.database.DBVisualizer;
import com.example.lab_2_db.database.DatabaseManager;
import com.example.lab_2_db.model.Client;
import javafx.application.Application;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class HelloApplication extends Application {
    @Override
    public void start(Stage stage) throws IOException, ClassNotFoundException, SQLException {
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "Jeka31312565";
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection connection = DriverManager.getConnection(url, user, password);
        DatabaseManager databaseManager = new DatabaseManager(connection);
        DBVisualizer dbVisualizer = new DBVisualizer(databaseManager);
        dbVisualizer.showTables();
//        Class<Client> tableClass = Client.class; // Replace with your table class
//        DBVIz<Client> visualizer = new DBVIz<>(databaseManager, tableClass);
//        visualizer.showTable("Clients");
    }

    public static void main(String[] args) {
        launch();
    }
}