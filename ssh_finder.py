import socket
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor

# Function to check if SSH is running on a specific port
def check_ssh_port(ip, port):
    try:
        # Create a socket object
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(0.5)  # Timeout reduced to 0.5 seconds for faster scanning
        result = sock.connect_ex((ip, port))  # Try connecting to the IP and port
        
        # If result is 0, it means the connection was successful
        if result == 0:
            # Attempt to verify if it's SSH by sending a simple SSH banner request
            sock.send(b"SSH-2.0-Check\r\n")
            response = sock.recv(1024).decode('utf-8', errors='ignore')
            if "SSH" in response:
                print(f"SSH service found on port {port}")
            else:
                print(f"Port {port} is open, but no SSH banner detected.")
        sock.close()
    except (socket.timeout, socket.error):
        pass  # Ignore errors (e.g., timeout or port unreachable)

# Function to scan ports using multi-threading
def scan_ports(ip):
    print(f"Starting port scan on {ip} at {datetime.now()}")
    
    # Create a ThreadPoolExecutor to scan ports concurrently
    with ThreadPoolExecutor(max_workers=100) as executor:
        # Scan ports 1 to 65535 concurrently
        for port in range(1, 65536):
            executor.submit(check_ssh_port, ip, port)

# Replace with the target IP
target_ip = "Ip here"
scan_ports(target_ip)
