package com.example.lab_2_db.model;

import lombok.*;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class UserInfo {
    private String username;
    private String accountLocked;
    private String passwordExpired;
}
