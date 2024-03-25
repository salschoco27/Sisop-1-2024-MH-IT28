#!/bin/bash
encryption() {
    echo -n "$1" | base64
}
encrypted_password=$(encryption "$password")

check_duplicate_email() {
    local email=$1
    grep -q "^$email:" user.txt
    return $?
}

#check admin/not
    if [[ "$email" == admin ]]; then
        user_type="admin"
    fi

register_user() {
    local email=$1
    local username=$2
    local sec_quest=$3
    local answer=$4
    local password=$5
    local user_type="user"  

      check_duplicate_email "$email"
    if [ $? -eq 0 ]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER FAILED] Failed registration with email $email because it’s already registered. " >> auth.log
        echo "Failed registration with email $email because it’s already registered. "
        exit 1
    fi

    echo "$email:$username:$sec_quest:$answer:$encrypted_password:$user_type" >> user.txt

    if [[ $user_type == "admin" ]]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] Admin $username registered successfully." >> auth.log
        echo "Admin $username registered successfully."
    else
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] user $username registered successfully." >> auth.log
        echo "User $username registered successfully."
    fi
}

touch user.txt
echo "Welcome to Registration System"
echo "Enter your email: "; read email
echo "Enter your username: " ; read username
echo "Enter a security question: "  ; read sec_quest
echo "Enter the answer to yout security question: "; read answer
read -sp "Enter a password(minimum 8 characters, at least 1 UPPERCASE letter, 1 lowercase letter, 1 digit, 1 symbol, and not the same as username, birthdate, or name): " password
echo

#verify pw
while true; do
    if [[ ${#password} -lt 8 || !("$password" =~ [[:lower:]]) || !("$password" =~ [[:upper:]]) || !("$password" =~ [0-9]) ]]; then
        #echo "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit."
        read -sp "Password: " password
        echo
    else
        break
    fi
done

register_user "$email" "$username" "$sec_quest" "$answer" "$password"
