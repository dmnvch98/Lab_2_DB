module com.example.lab_2_db {
    requires javafx.controls;
    requires javafx.fxml;
    requires lombok;
    requires java.sql;


    opens com.example.lab_2_db to javafx.fxml;
    exports com.example.lab_2_db;
}