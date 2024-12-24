#include <iostream>
#include <sstream>

#define OLC_PGE_APPLICATION
// ReSharper disable once CppUnusedIncludeDirective
#include "olcPixelGameEngine.h"

class PgeApp final : public olc::PixelGameEngine {
public:
    PgeApp() { sAppName = "PGE Demo App"; }

private:

private:
    bool OnUserCreate() override {
        return true;
    }

    bool OnUserUpdate(float fElapsedTime) override {
        Clear(olc::DARK_BLUE);
        return true;
    }
};


int main() {
    std::cout << "Starting" << std::endl;
    PgeApp pgeApp;
    pgeApp.Construct(800, 480, 2, 2);
    pgeApp.Start();
    return 0;
}
