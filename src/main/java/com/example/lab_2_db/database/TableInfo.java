package com.example.lab_2_db.database;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TableInfo {
    private String name;
    private String engine;
    private String primaryKey;
    private String updateTime;
}

