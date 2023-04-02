// Created by andrescabana86 on 8/3/2023.
#include "crow_all.h"
#include <fstream>
#include <unistd.h>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <boost/filesystem.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/stdx.hpp>
#include <mongocxx/uri.hpp>
#include <mongocxx/instance.hpp>

void sendFile(crow::response &res, std::string filename, std::string contentType) {
    std::ifstream in("../public/" + filename, std::ifstream::in);
    if (!in.fail()) {
        std::ostringstream contents;
        contents << in.rdbuf();
        in.close();
        res.set_header("Content-Type", contentType);
        res.write(contents.str());
    } else {
        res.code = 404;
        res.write("Not Found");
    }
    res.end();
}

void sendHtml(crow::response &res, std::string filename) {
    sendFile(res, filename + ".html", "text/html");
}


void sendImage(crow::response &res, std::string filename) {
    sendFile(res, "image/" + filename, "image/jpeg");
}


void sendScript(crow::response &res, std::string filename) {
    sendFile(res, "script/" + filename, "text/javascript");
}

void sendComponent(crow::response &res, std::string filename) {
    sendFile(res, "script/component/" + filename, "text/javascript");
}

void sendStyle(crow::response &res, std::string filename) {
    sendFile(res, "style/" + filename, "text/css");
}

int main() {
    crow::SimpleApp app;
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != nullptr) {
        std::cout << "current directory => " << cwd << std::endl;
    }

    CROW_ROUTE(app, "/")
            ([](const crow::request &req, crow::response &res) {
                sendHtml(res, "index");
            });
    CROW_ROUTE(app, "/style/<string>")
            ([](const crow::request &req, crow::response &res, std::string filename) {
                sendStyle(res, filename);
            });
    CROW_ROUTE(app, "/script/<string>")
            ([](const crow::request &req, crow::response &res, std::string filename) {
                sendScript(res, filename);
            });
    CROW_ROUTE(app, "/component/<string>")
            ([](const crow::request &req, crow::response &res, std::string filename) {
                sendComponent(res, filename);
            });
    CROW_ROUTE(app, "/image/<string>")
            ([](const crow::request &req, crow::response &res, std::string filename) {
                sendImage(res, filename);
            });

    char* port = getenv("PORT");
    uint16_t iPort = static_cast<uint16_t>(port != NULL ? std::stoi(port) : 8080);
    std::cout << "PORT = " << iPort << std::endl;
    app.port(iPort).multithreaded().run();

    return 0;
}