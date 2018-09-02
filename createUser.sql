CREATE DATABASE myProject;
CREATE USER 'myProject'@'localhost' IDENTIFIED BY 'Iamking123!';
GRANT ALL PRIVILEGES ON myProject.* TO 'myProject'@'localhost';
FLUSH PRIVILEGES;