function teleport_login -d "Automate login to Teleport using 1Password credentials"
    for arg in $argv
        switch $arg
            case '--help'
                set_color cyan; echo "Teleport Login Automation Script"; set_color normal
                echo "Usage:"
                set_color yellow; echo "    teleport_login [--help]"; set_color normal
                echo ""
                set_color cyan; echo "Environment Variables:"; set_color normal
                set_color green
                echo "    OPTP_PROXY"
                echo "        Description: Identifier for the 1Password item containing Teleport credentials."
                echo "        Example: set -gx OPTP_PROXY 'teleport.example.com'"
                set_color normal
                return
        end
    end

    if not set -q OPTP_PROXY
        echo "OPTP_PROXY environment variable not set. Run 'teleport_login --help' for more information." >&2
        return 1
    end


    # Teleport login logic
    set -l teleport_status
    tsh status 2>&1 | read -z teleport_status

    if string match -q "*Logged in as*" $teleport_status
        if not string match -q "*[EXPIRED]*" $teleport_status
            # Print colored header
            set_color magenta
            echo "You are already logged in to Teleport:"
            set_color normal
            echo ""

            # Print each line of the teleport_status directly
            for line in (string split \n $teleport_status)
                # Skip lines that are empty or consist of whitespace only
                if not string match -q -r '\S' $line
                    continue
                end

                echo $line
            end

            # Print colored footer
            echo ""
            set_color yellow
            echo "To logout, use this command:"
            set_color green
            echo "tsh logout"
            set_color normal
            return 2
        end
    end

    # Extract the top-level domain from OPTP_PROXY
    set -l domain_parts (string split '.' $OPTP_PROXY)
    set -l domain_name (string join '.' $domain_parts[-2..-1])

    # Fetch item from 1Password using the top-level domain
    set -l item (op item get $domain_name)
    if not test $status -eq 0
        echo "Failed to get item from 1Password for $domain_name" >&2
        return 1
    end

    set -l username (echo $item | string match -r 'username:\s+\S+' | string trim | string replace -r 'username:\s+' '')
    set -l password (echo $item | string match -r 'password:\s+\S+' | string trim | string replace -r 'password:\s+' '')
    set -l otp (echo $item | string match -r 'one-time password:\s+\S+' | string trim | string replace -r 'one-time password:\s+' '')

    if not set -q username
        echo "Username not found in 1Password item for $OPTP_PROXY" >&2
        return 1
    end

    if not set -q password
        echo "Password not found in 1Password item for $OPTP_PROXY" >&2
        return 1
    end

    if not set -q otp
        echo "One-time password not found in 1Password item for $OPTP_PROXY" >&2
        return 1
    end


    expect -c "
        log_user 0
        spawn tsh login --proxy $OPTP_PROXY --user $username
        expect {
            -re \"Enter password for Teleport user $username:\" {
                send -- \"$password\r\"
                exp_continue
            }
            -re \"Enter an OTP code from a device:\" {
                send -- \"$otp\r\"
            }
        }
        interact
    "
end
