#!/bin/bash
# Patch_Disable_shellinabox_SSL.sh
# sudo curl https://www.bi7jta.cn/files/AndyTaylorTweet/updateScripts/Patch_Disable_shellinabox_SSL.sh | sudo sh
 
file_path="/etc/default/shellinabox"
new_line='SHELLINABOX_ARGS="--no-beep --disable-ssl-menu --disable-ssl --css=/etc/shellinabox/options-enabled/00_White\ On\ Black.css"'

# Check if the file exists
if [ -f "$file_path" ]; then

    # 删除包含 "enabled/00_White On Black.css" 的不带\转移符到行
    if grep -q "00_White On Black.css" "$file_path"; then
        # 删除包含指定字符串的行
        sed -i '/00_White On Black.css/d' "$file_path"
        echo "包含 '00_White On Black.css' 的行已删除"
    fi 

    # Check if the file does not contain "--disable-ssl"
    #if ! grep -q "--disable-ssl" "$file_path"; then
    if ! grep -q -- "--disable-ssl" "$file_path"; then
        # Delete lines starting with "SHELLINABOX_ARGS"
        sed -i '/^SHELLINABOX_ARGS/d' "$file_path"
        # Add new line
        echo "$new_line" >> "$file_path"

        cat $file_path

        echo "Operation completed, now restart shellinabox"
        systemctl restart shellinabox.service
        
    else
        echo "The file already contains --disable-ssl, no modification needed"
    fi
else
    echo "File $file_path does not exist"
fi


