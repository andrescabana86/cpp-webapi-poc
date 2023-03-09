//
// Created by andrescabana86 on 8/3/2023.
//
#include "crow_all.h"

int main() {
    crow::SimpleApp app;
    CROW_ROUTE(app, "/")
            ([]() {
                return "<div>Hellow world!</div>";
            });

    char* port = getenv("PORT");
    uint16_t iPort = static_cast<uint16_t>(port != NULL ? std::stoi(port) : 18080);
    std::cout << "PORT = " << iPort << std::endl;

    app.port(iPort).multithreaded().run();

    return 0;
}