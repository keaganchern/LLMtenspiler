#include <iostream>
#include <vector>
#include <chrono>

using namespace std;
using namespace std::chrono;

vector<float> normal_blend_f(vector<float> base, vector<float> active, float opacity)
{
  vector<float> out;
  for (int i = 0; i < base.size(); ++i)
    out.push_back(opacity * active[i] + (1 - opacity) * base[i]);

  return out;
}
