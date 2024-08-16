# diagram.py
#---------------------------------------------------------------------------------------------------------------
from diagrams import Diagram
from diagrams.generic.network import Router, Switch, Firewall
from diagrams.onprem.client import Users
from diagrams.onprem.client import Client
from diagrams.onprem.network import Internet
from diagrams.onprem.compute import Server
from diagrams.saas.chat import Discord
graph_attr = {
    "fontsize": "45",
    "bgcolor": "transparent"
}
with Diagram("Wake on Wan(WOW) Via discord server", show=False, graph_attr=graph_attr):
    Usuario=Users("Usuário")
    Discord=Discord("Discord Server")
    Internet=Internet("Internet")
    wow_server = Server("Servidor Wake on Wan")
    Roteador= Router("Roteador")
    Firewall = Firewall("Firewall")
    Cliente= Client("Computador")

    Usuario>>Discord>>Internet>>wow_server>>Roteador>>Firewall>>Cliente
#---------------------------------------------------------------------------------------------------------------
