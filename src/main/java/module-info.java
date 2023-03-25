module com.example.lab_2_db {
    requires javafx.controls;
    requires javafx.fxml;
    requires lombok;
    requires java.sql;
    requires mysql.connector.j;


    opens com.example.lab_2_db to javafx.fxml;
    exports com.example.lab_2_db;
    opens com.example.lab_2_db.database to javafx.base;
}