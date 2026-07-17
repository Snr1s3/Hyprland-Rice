#pip install netifaces
import netifaces

def get_network_interfaces():
    return netifaces.interfaces()


def get_ip_address(interface):
    try:
        addr = netifaces.ifaddresses(interface)
        return addr[netifaces.AF_INET][0]['addr']
    except:
        return "No internet"
    
#MAIN
#print(get_network_interfaces())
for(interface) in get_network_interfaces():
    #print(interface)
    a= get_ip_address(interface)
    if "192.168" in a:
        print(str(a))
        break