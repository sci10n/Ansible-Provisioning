# ansible-deployment
Ansible roles and playbooks

Addition to .bashrc for gpg-agent
```
export GPG_AGENT_INFO
unset SSH_AGENT_PID
         if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
           export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
         fi

export SSH_AUTH_SOCK
export GPG_TTY=$(tty)
```
