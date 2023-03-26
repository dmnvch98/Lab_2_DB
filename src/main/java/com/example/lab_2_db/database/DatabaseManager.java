package com.example.lab_2_db.database;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Data
@AllArgsConstructor
public class DatabaseManager {
    private Connection connection;

    public ResultSet executeQuery(String query) throws SQLException {
        Statement statement = connection.createStatement();
        return statement.executeQuery(query);
    }

    public int executeUpdate(String query) throws SQLException {
        Statement statement = connection.createStatement();
        return statement.executeUpdate(query);
    }

    public void modifyDatabase(String query) throws SQLException {
        Statement statement = connection.createStatement();
        statement.execute(query);
    }

    public List<String> getTableNames() throws SQLException {
        List<String> tableNames = new ArrayList<>();
        ResultSet rs = executeQuery("SHOW TABLES");
        while (rs.next()) {
            tableNames.add(rs.getString(1));
        }
        return tableNames;
    }

    public List<TableInfo> getTableInfos() throws SQLException {
        List<TableInfo> tableInfos = new ArrayList<>();
        ResultSet resultSet = executeQuery("SHOW TABLE STATUS");

        while (resultSet.next()) {
            String name = resultSet.getString("Name");
            String engine = resultSet.getString("Engine");
            String updateTime = resultSet.getString("Update_time");
            String primaryKey = getPrimaryKeyName(name);
            TableInfo tableInfo = new TableInfo(name, engine, primaryKey, updateTime);
            tableInfos.add(tableInfo);
        }

        return tableInfos;
    }

    private String getPrimaryKeyName(String table) throws SQLException {
        ResultSet resultSet = executeQuery("SHOW INDEX FROM " + table + " WHERE Key_name = 'PRIMARY';");
        while (resultSet.next()) {
            return resultSet.getString("Column_name");
        }
        return "";
    }

//    public List<ForeignKeyInfo> getForeignKeyInfos(String tableName) throws SQLException {
//        List<ForeignKeyInfo> foreignKeyInfos = new ArrayList<>();
//        ResultSet resultSet = executeQuery("SHOW CREATE TABLE " + tableName);
//        String patternString = "CONSTRAINT `(\\w+)` FOREIGN KEY \\(`(.+?)`\\) REFERENCES `(\\w+)` \\(`(.+?)`\\)";
//        Pattern pattern = Pattern.compile(patternString);
//
//        while (resultSet.next()) {
//            String createTableStatement = resultSet.getString(2);
//            Matcher matcher = pattern.matcher(createTableStatement);
//
//            while (matcher.find()) {
//                String constraintName = matcher.group(1);
//                String columnName = matcher.group(2);
//                String referencedTableName = matcher.group(3);
//                String referencedColumnName = matcher.group(4);
//                ForeignKeyInfo foreignKeyInfo = new ForeignKeyInfo(constraintName, tableName, columnName, referencedTableName, referencedColumnName);
//                foreignKeyInfos.add(foreignKeyInfo);
//            }
//        }
//
//        return foreignKeyInfos;
//    }
public List<ForeignKeyInfo> getForeignKeyInfos(String tableName) throws SQLException {
    List<ForeignKeyInfo> foreignKeyInfos = new ArrayList<>();
    String query = "SELECT i.TABLE_NAME, i.CONSTRAINT_NAME, k.COLUMN_NAME, k.REFERENCED_TABLE_NAME, k.REFERENCED_COLUMN_NAME " +
        "FROM information_schema.TABLE_CONSTRAINTS i " +
        "LEFT JOIN information_schema.KEY_COLUMN_USAGE k ON i.CONSTRAINT_NAME = k.CONSTRAINT_NAME " +
        "WHERE i.CONSTRAINT_TYPE = 'FOREIGN KEY' " +
        "AND i.TABLE_SCHEMA = DATABASE() " +
        "AND i.TABLE_NAME = ?";
    PreparedStatement statement = connection.prepareStatement(query);
    statement.setString(1, tableName);
    ResultSet resultSet = statement.executeQuery();

    while (resultSet.next()) {
        String constraintName = resultSet.getString("CONSTRAINT_NAME");
        String columnName = resultSet.getString("COLUMN_NAME");
        String referencedTableName = resultSet.getString("REFERENCED_TABLE_NAME");
        String referencedColumnName = resultSet.getString("REFERENCED_COLUMN_NAME");
        ForeignKeyInfo foreignKeyInfo = new ForeignKeyInfo(constraintName, tableName, columnName, referencedTableName, referencedColumnName);
        foreignKeyInfos.add(foreignKeyInfo);
    }

    return foreignKeyInfos;
}

}
