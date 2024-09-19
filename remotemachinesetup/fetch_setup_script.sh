#!/usr/bin/env bash

server=
port=

setup_dir="."
config_dir="machine_configurations"

[[ -d "$setup_dir"/"$config_dir" ]] ||
    mkdir -p "$setup_dir"/"$config_dir" ||
    sudo mkdir -p "$setup_dir"/"$config_dir"

download-setup-scripts() {
    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.withGIT" -o "$setup_dir"/.withGIT

    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.generic" -o "$setup_dir"/"$config_dir"/.generic
    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.server" -o "$setup_dir"/"$config_dir"/.server
    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.dnsserver" -o "$setup_dir"/"$config_dir"/.dnsserver
    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.custom" -o "$setup_dir"/"$config_dir"/.custom
    curl "http://devbox10:9000/data/devbox10/ubuntu-setup/.k8" -o "$setup_dir"/"$config_dir"/.k8

    chmod +x "$setup_dir"/.withGIT
}

execute-setup-scripts() {
    # ./"$setup_dir"/.withGIT --input-source=file --config-type=generic --repo-version=dev
    # ./"$setup_dir"/.withGIT --input-source=file --config-type=generic --repo-version=stable
    # ./"$setup_dir"/.withGIT --input-source=file --config-type=k8 --repo-version=dev
    # ./"$setup_dir"/.withGIT --input-source=file --config-type=k8 --repo-version=stable

    # [REMEMBER]: EITHER PROVIDE ALL THE ARGUMENTS OR NONE
    ./"$setup_dir"/.withGIT
}

read-input-from-cmdline() {
    read -p "Fetch from which server [default: devbox10] ? " server
    read -p "Enter server-port (default: 9000] = " port

    [[ -n "$server" ]] || server=devbox10
    [[ -n "$port" ]] || port=9000
}

show-values() {
    echo -e "server: $server"
    echo -e "port: $port"
}

if [[ "$#" -gt 0 ]]; then
    for arg in "$@"; do
        case $arg in
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
else
    read-input-from-cmdline
fi

show-values
download-setup-scripts
execute-setup-scripts
