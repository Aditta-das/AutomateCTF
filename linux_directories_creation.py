import os

class LinuxDupli:
    def __init__(self):
        self.linux_structure = [
            "/bin",
            "/boot",
            "/dev",
            "/etc",
            "/etc/apt",
            "/etc/init.d",
            "/etc/systemd",
            "/home/fakeditta",
            "/home/faketultul",
            "/lib",
            "/lib64",
            "/media",
            "/mnt",
            "/opt",
            "/proc",
            "/root",
            "/run",
            "/sbin",
            "/srv",
            "/sys",
            "/tmp",
            "/usr",
            "/usr/bin",
            "/usr/lib",
            "/usr/local",
            "/usr/local/bin",
            "/usr/local/lib",
            "/var",
            "/var/log",
            "/var/tmp",
            "/var/www",
            "/var/www/html",
        ]
        self.flags = [
            "thm{27984sjashakh29sdajskas}",
            "thm{934ksj12kdhs9jfh27xnsjd}",
            "thm{u29dhsk1837saksjdfhs930}",
            "thm{ab83jdks82jslakshd93jf8}",
            "thm{x28sh29shd92jhsjs73jak2}",
            "thm{73jsd7ks930xjdksl29shks}",
        ]

    def create_files(self, file_path, flag_index):
        """
        Create a file with a flag at the specified file path.
        """
        try:
            with open(file_path, "w") as file:
                file.write(self.flags[flag_index])
            print(f"Created flag file: {file_path}")
        except Exception as e:
            print(f"Error creating flag file {file_path}: {e}")

    def create_directories(self, base_path):
        """
        Create the Linux-like directory structure.
        """
        try:
            for path in self.linux_structure:
                # Build the full path
                full_path = os.path.join(base_path, path.lstrip("/"))
                # Create the directory if it doesn't exist
                os.makedirs(full_path, exist_ok=True)
                print(f"Created: {full_path}")

                # Special condition to place flag files in specific directories
                if path == "/home/fakeditta":
                    flag_path = os.path.join(full_path, "flag1.txt")
                    self.create_files(flag_path, 0)
                elif path == "/home/faketultul":
                    flag_path = os.path.join(full_path, "flag.txt")
                    self.create_files(flag_path, 1)
                elif path == "/var/www/html":
                    flag_path = os.path.join(full_path, "flag2.txt")
                    self.create_files(flag_path, 2)
                elif path == "/root":
                    flag_path = os.path.join(full_path, "user.txt")
                    self.create_files(flag_path, 3)
                    root_path = os.path.join(full_path, "root.txt")
                    self.create_files(root_path, 4)
                elif path == "/usr/bin":
                    flag_path = os.path.join(full_path, "flag5.txt")
                    self.create_files(flag_path, 5)

        except Exception as e:
            print(f"Error: {e}")


# Run the function to create the directory structure
if __name__ == "__main__":
    base_path = input("Enter Base Path >> ")
    fklinux = LinuxDupli()
    fklinux.create_directories(base_path)
