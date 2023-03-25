package com.example.lab_2_db.database;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

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
            TableInfo tableInfo = new TableInfo(name, engine);
            tableInfos.add(tableInfo);
        }

        return tableInfos;
    }

    public List<ForeignKeyInfo> getForeignKeyInfos(String tableName) throws SQLException {
        List<ForeignKeyInfo> foreignKeyInfos = new ArrayList<>();
        ResultSet resultSet = executeQuery("SHOW CREATE TABLE " + tableName);

        while (resultSet.next()) {
            String createTableStatement = resultSet.getString(2);
            String[] lines = createTableStatement.split("\\r?\\n");
            for (String line : lines) {
                if (line.contains("FOREIGN KEY")) {
                    String[] words = line.split("\\s+");
                    String constraintName = words[2];
                    String columnName = words[3].substring(1, words[3].length() - 1);
                    String referencedTableName = words[5];
                    String referencedColumnName = words[6].substring(1, words[6].length() - 1);
                    ForeignKeyInfo foreignKeyInfo = new ForeignKeyInfo(constraintName, "[table_name]", columnName, referencedTableName, referencedColumnName);
                    foreignKeyInfos.add(foreignKeyInfo);
                }
            }
        }
        return foreignKeyInfos;
    }


}
