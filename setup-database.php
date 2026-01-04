<?php
/**
 * Database Setup Script
 * Run this before migrations to ensure database exists
 */

$host = '127.0.0.1';
$username = 'root';
$password = '';
$database = 'laravel';

// Connect to MySQL without selecting a database
$connection = new mysqli($host, $username, $password);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}

// Check if database exists
$result = $connection->query("SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{$database}'");

if ($result->num_rows == 0) {
    // Create database if it doesn't exist
    if ($connection->query("CREATE DATABASE `{$database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")) {
        echo "Database '{$database}' created successfully!\n";
    } else {
        die("Error creating database: " . $connection->error);
    }
} else {
    echo "Database '{$database}' already exists.\n";
}

$connection->close();
echo "Database setup complete.\n";
