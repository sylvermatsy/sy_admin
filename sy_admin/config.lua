Admin, Required, TP = {}, {}, {}

Control = {
  MenuAdmin = 'F11',
  NoClip = 'F9',
}

Admin.Acces = {
    General =  {"mod", "admin", "superadmin", "_dev", "owner"},
    Noclip = {"admin", "superadmin", "_dev", "owner"},
    TPM = {"admin", "superadmin", "_dev", "owner"},
    ChatStaff = {"mod", "admin", "superadmin", "_dev", "owner"},
    GiveCar = {"superadmin"}
}

Required = {
    NoClip = true, -- true / false (true il faut le staff mode pour no clip | false il ne faut pas le staff mode pour noclip)
    TPM = true -- true / false (true il faut le staff mode pour tp marqueur | false il ne faut pas le staff mode pour tp marqueur)
}

TP = {
    MASEBANK = vector3(-75.37, -818.83, 326.17),
    PC = vector3(216.47, -810.10, 30.71),
    Hopital = vector3(294.94, -570.19, 43.13),
    PDP = vector3(418.51, -986.29, 29.39),
    Vetement = vector3(428.53, -800.07, 29.49),
    SandyShores = vector3(1724.91, 3710.38, 34.26),
    Paleto = vector3(123.37, 6627.40, 31.92),
    Epicerie = vector3(28.97, -1351.03, 29.34)
}

NAMEBUTTOM = {
   Report = "~b~→~s~  Gestion reports",
   Player = "~b~→~s~  Liste des joueurs",
   Perso = "~b~→~s~  Option personnel",
   Vehicle = "~b~→~s~  Option véhicule",
   Item = "~b~→~s~  Liste items",
}

coordsmenu = {
    mainColor = "~b~",
    CHAR = 'CHAR_MP_DETONATEPHONE' ---- https://wiki.rage.mp/index.php?title=Notification_Pictures
}
