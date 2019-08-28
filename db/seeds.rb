######################## Create superadmin ########################
User.create(email: "dyron@live.com", password: "coltax007", password_confirmation: "coltax007", role: User.roles[:super])
