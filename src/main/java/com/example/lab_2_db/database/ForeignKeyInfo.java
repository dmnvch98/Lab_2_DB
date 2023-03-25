package com.example.lab_2_db.database;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ForeignKeyInfo {
    private String constraintName;
    private String tableName;
    private String columnName;
    private String referencedTableName;
    private String referencedColumnName;
}
