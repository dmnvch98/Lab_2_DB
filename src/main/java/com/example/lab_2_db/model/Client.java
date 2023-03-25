package com.example.lab_2_db.model;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Client {
    private Long id;
    private String phone;
    private String firstName;
    private String lastName;

}
