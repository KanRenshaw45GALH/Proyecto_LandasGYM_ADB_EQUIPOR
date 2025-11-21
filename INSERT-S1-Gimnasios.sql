----INSERCION DE DATOS POR INSERT COMPLETO S1
USE LandasGYM;

----GIMNASIOS
INSERT INTO ElementosGimnasio.Gimnasio (Nombre, Direccion, Telefono, Email) VALUES
('Gym_01 Center', 'Av. España #760, Santa Ana', '6501-4657', 'contacto.gym1@hotmail.com'),
('Gym_02 Center', 'Camino Real #90, Chalatenango', '6864-1520', 'contacto.gym2@gmail.com'),
('Gym_03 Center', 'Av. Siempre Viva #239, Sonsonate', '7232-1434', 'contacto.gym3@mail.com'),
('Gym_04 Fit', 'Camino Real #430, Soyapango', '6919-5557', 'contacto.gym4@gmail.com'),
('Gym_05 Fit', 'Calle Principal #349, Santa Ana', '6318-4527', 'contacto.gym5@outlook.com'),
('Gym_06 Center', 'Calle Central #390, Santa Tecla', '6735-6635', 'contacto.gym6@mail.com'),
('Gym_07 Pro', 'Av. España #748, Ahuachapán', '7098-3045', 'contacto.gym7@yahoo.com'),
('Gym_08 Center', 'Camino Real #301, Chalatenango', '7813-6925', 'contacto.gym8@mail.com'),
('Gym_09 Fit', 'Calle Central #47, Soyapango', '7583-5741', 'contacto.gym9@gmail.com'),
('Gym_10 Fit', 'Calle Central #390, Santa Ana', '6928-6977', 'contacto.gym10@hotmail.com'),
('Gym_11 Pro', 'Av. Reforma #215, Santa Ana', '7437-2169', 'contacto.gym11@mail.com'),
('Gym_12 Fit', 'Camino Real #747, Soyapango', '6334-8573', 'contacto.gym12@yahoo.com');


SELECT * FROM ElementosGimnasio.Gimnasio;
SELECT * FROM AuditHistorial;