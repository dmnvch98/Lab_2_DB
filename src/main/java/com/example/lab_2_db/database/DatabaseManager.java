package com.example.lab_2_db.database;

import java.sql.*;
import lombok.*;

@Data
@AllArgsConstructor
public class DatabaseManager {
    private Connection connection;
    
    public ResultSet executeQuery(String query) throws SQLException {
        PreparedStatement statement = (PreparedStatement) connection.createStatement();
        return statement.executeQuery(query);
    }
    
    public int executeUpdate(String query) throws SQLException {
        PreparedStatement statement = (PreparedStatement) connection.createStatement();
        return statement.executeUpdate(query);
    }
    
    public void modifyDatabase(String query) throws SQLException {
        PreparedStatement statement = (PreparedStatement) connection.createStatement();
        statement.execute(query);
    }
}
