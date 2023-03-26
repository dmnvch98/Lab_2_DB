package com.example.lab_2_db.alerts;

import javafx.scene.control.Alert;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.Value;

@Builder
@Value
@RequiredArgsConstructor
public class ErrorAlert {
    String message;
    public void showAlert() {
        Alert infoAlert = new Alert(Alert.AlertType.ERROR);
        infoAlert.setTitle("Error");
        infoAlert.setContentText(message);
        infoAlert.showAndWait();
    }
}
