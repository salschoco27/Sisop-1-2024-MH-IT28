#!/bin/bash
decryption() {
    echo "$1" | base64 -d
}
save_pw_decrypted=$(decryption "$save_pw")

check_pw() {
    local email=$1
    local password=$2
    local save_pw=$(grep "^$email:" user.txt | cut -d: -f5)
    local admincheck=$(grep "^$email:" user.txt | cut -d: -f6)

    if [ "$password" == "$save_pw_decrypted" ]; then
        return 0
    else
        return 1
    fi
}

pw_forgot() {
    local email=$1
    local sec_quest=$(grep "^$email:" user.txt | cut -d: -f3)
    local correct_answer=$(grep "^$email:" user.txt | cut -d: -f4)
    read -p "Security Question: $sec_quest " user_answer

    if [ "$user_answer" == "$correct_answer" ]; then
        local save_pw=$(grep "^$email:" user.txt | cut -d: -f5)
        save_pw_decrypted=$(decryption "$save_pw")
        echo "Your password is: $save_pw_decrypted"
    else
        echo "Your answer is incorrect."
    fi
}

admin_menu() {
    echo "Admin Menu:"
    echo "1. Add User"
    echo "2. Edit User"
    echo "3. Delete User"
    read action
    case $action in
        1)
            ./register.sh
            ;;
        2)
            ./edit_user.sh
            ;;
        3)
            ./delete_user.sh
            ;;
        *)
            echo "Choose 1, 2, or 3!"
            ;;
    esac
}

echo "Welcome  to Login System"
echo "1. Login"
echo "2. Forgot Password"
read option
case $option in
    1)
        read -p "Enter your email: " email
        read -sp "Enter your password: " password
        echo
        grep -q "^$email:" user.txt
        if [ $? -ne 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR Failed login attempt on user with email $email" >> auth.log
            echo "ERROR Failed login attempt on user with email $email"
            exit 1
        fi

#verif pw
        check_pw "$email" "$password"
        if [ $? -eq 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN SUCCESS] Login succeeded." >> auth.log

            admincheck=$(grep "^$email:" user.txt | cut -d: -f6)
            if [ "$admincheck" == "admin" ]; then
                admin_actions
            else
                echo "You do not have admin privileges. Welcome!"
            fi
        else
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR Password Incorrect" >> auth.log
            echo "ERROR Password Incorrect"
            read -p "Forgot Password? (Y/N): " choice
            if [ "$choice" == "Y" ]; then
                pw_forgot "$email"
            fi
        fi
        ;;
    2)
        read -p "Enter your email: " email
        pw_forgot "$email"
        ;;
    *)
        echo "Choose 1 or 2!"
        ;;
esac
