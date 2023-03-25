package com.example.lab_2_db;

import lombok.experimental.UtilityClass;

@UtilityClass
public class Utils {
    public static String snakeCaseToCamelCase(String input) {
        StringBuilder output = new StringBuilder();
        boolean capitalizeNext = false;
        for (int i = 0; i < input.length(); i++) {
            char currentChar = input.charAt(i);
            if (currentChar == '_') {
                capitalizeNext = true;
            } else {
                if (capitalizeNext) {
                    output.append(Character.toUpperCase(currentChar));
                    capitalizeNext = false;
                } else {
                    output.append(Character.toLowerCase(currentChar));
                }
            }
        }
        return output.toString();
    }

    public static String camelCaseToSnakeCase(String input) {
        return input.replaceAll("([a-z])([A-Z])", "$1_$2").toLowerCase();
    }


}
