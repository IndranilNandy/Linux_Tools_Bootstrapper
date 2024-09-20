#!/usr/bin/env bash

server=
port=
# Values: git|httpserver [default: git]
inst_medium=httpserver

setup_dir="."
config_dir="machine_configurations"

[[ -d "$setup_dir"/"$config_dir" ]] ||
    mkdir -p "$setup_dir"/"$config_dir" ||
    sudo mkdir -p "$setup_dir"/"$config_dir"

download-setup-scripts() {
    # curl "http://$server:$port/data/$server/ubuntu-setup/.withGIT" -o "$setup_dir"/.withGIT

    echo -e "Overriding existing machine-config files with more specific ones received from the server"
    curl "http://$server:$port/data/$server/ubuntu-setup/local_configs/.generic" -o "$setup_dir"/"$config_dir"/.generic
    curl "http://$server:$port/data/$server/ubuntu-setup/local_configs/.server" -o "$setup_dir"/"$config_dir"/.server
    curl "http://$server:$port/data/$server/ubuntu-setup/local_configs/.dnsserver" -o "$setup_dir"/"$config_dir"/.dnsserver
    curl "http://$server:$port/data/$server/ubuntu-setup/local_configs/.custom" -o "$setup_dir"/"$config_dir"/.custom
    curl "http://$server:$port/data/$server/ubuntu-setup/local_configs/.k8" -o "$setup_dir"/"$config_dir"/.k8

    chmod +x "$setup_dir"/.withGIT
}

execute-setup-scripts() {
    # [REMEMBER]: EITHER PROVIDE ALL THE ARGUMENTS OR NONE
    ./"$setup_dir"/.withGIT
}

read-input-from-cmdline() {
    read -p "Installation medium [git|httpserver] [default: git] ? " inst_medium
    [[ -n "$inst_medium" ]] || inst_medium=httpserver

    if [[ "$inst_medium" == "httpserver" ]]; then
        read -p "Fetch from which server [default: devbox10] ? " server
        read -p "Enter server-port (default: 9000] = " port

        [[ -n "$server" ]] || server=devbox10
        [[ -n "$port" ]] || port=9000

        curl http://$server:$port ||
            {
                inst_medium=git
                echo -e "$server:$port is not available. Switching installation medium to $inst_medium"
            }
    fi
}

show-values() {
    echo -e "Installation medium: $inst_medium"
    echo -e "server: $server"
    echo -e "port: $port"
}

if [[ "$#" -gt 0 ]]; then
    for arg in "$@"; do
        case $arg in
        --medium=*)
            inst_medium=$(echo $arg | sed "s/--medium=\(.*\)/\1/")
            ;;
        --server=*)
            server=$(echo $arg | sed "s/--server=\(.*\)/\1/")
            ;;
        --port=*)
            port=$(echo $arg | sed "s/--port=\(.*\)/\1/")
            ;;
        *)
            echo -e "Invalid argument: $arg" && exit 1
            ;;
        esac
    done

    if [[ "$inst_medium" == "httpserver" ]]; then
        curl http://$server:$port ||
            {
                inst_medium=git
                echo -e "$server:$port is not available. Switching installation medium to $inst_medium"
            }
    fi
else
    read-input-from-cmdline
fi

show-values
[[ "$inst_medium" == "httpserver" ]] && echo -e "Downloading setup-scripts from server $server" && download-setup-scripts
execute-setup-scripts
