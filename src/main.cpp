// Created by andrescabana86 on 8/3/2023.
#include "crow_all.h"
#include <fstream>
#include <unistd.h>
#include <iostream>

void sendFile(crow::response &res, const std::string& filename, const std::string& contentType) {
    std::ifstream in("./public/" + filename, std::ifstream::in);
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

void sendHtml(crow::response &res, const std::string& filename) {
    sendFile(res, filename + ".html", "text/html");
}


void sendImage(crow::response &res, const std::string& filename) {
    sendFile(res, "image/" + filename, "image/jpeg");
}


void sendScript(crow::response &res, const std::string& filename) {
    sendFile(res, "script/" + filename, "text/javascript");
}

void sendComponent(crow::response &res, const std::string& filename) {
    sendFile(res, "script/component/" + filename, "text/javascript");
}

void sendStyle(crow::response &res, const std::string& filename) {
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
            ([](const crow::request &req, crow::response &res, const std::string& filename) {
                sendStyle(res, filename);
            });
    CROW_ROUTE(app, "/script/<string>")
            ([](const crow::request &req, crow::response &res, const std::string& filename) {
                sendScript(res, filename);
            });
    CROW_ROUTE(app, "/component/<string>")
            ([](const crow::request &req, crow::response &res, const std::string& filename) {
                sendComponent(res, filename);
            });
    CROW_ROUTE(app, "/image/<string>")
            ([](const crow::request &req, crow::response &res, const std::string& filename) {
                sendImage(res, filename);
            });

    char* port = getenv("PORT");
    uint16_t iPort = static_cast<uint16_t>(port != nullptr ? std::stoi(port) : 8080);
    std::cout << "PORT = " << iPort << std::endl;
    app.port(iPort).multithreaded().run();

    return 0;
}