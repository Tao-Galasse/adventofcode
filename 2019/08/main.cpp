#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

#define HEIGHT 6
#define WIDTH 25

vector< vector<int> > get_layers_from_input() {
	ifstream file("input.txt");
	vector< vector<int> > layers;
	vector<int> layer;
	char digit;
	int index = 0;

	while (file.get(digit)) {
		layer.push_back(digit - '0'); // convert char to int and put it in the current layer
		
		index++;
		if (index % (HEIGHT * WIDTH) == 0) { // current layer is full
			layers.push_back(layer);
			layer.clear();
		}
	}
	file.close();

	return layers;
}


int count_digits_in_layer(vector<int> layer, char digit) {
	int total = 0;

	for (int i = 0; i < layer.size(); i++) {	
	    if (layer[i] == digit) {
	    	total++;
	    }
	}

	return total;
}

vector<int> get_layer_fewer_zeros(vector< vector<int> > layers) {
	vector<int> layer_fewer_zeros = layers[0];
	int min = count_digits_in_layer(layers[0], 0);

	for(int i = 1; i<layers.size(); i++) {
		int zeros = count_digits_in_layer(layers[i], 0);

		if (zeros < min) {
			min = zeros;
			layer_fewer_zeros = layers[i];
		}
	}

	return layer_fewer_zeros;
}

vector<int> decode_image(vector< vector<int> > layers) {
	vector<int> image;

	for (int pixel = 0; pixel < HEIGHT * WIDTH; pixel++) {
		for(int layer = 0; layer<layers.size(); layer++) {
			if (layers[layer][pixel] != 2) { // pixel is not transparent
				image.push_back(layers[layer][pixel]);
				break;
			}
		}
	}

	return image;
}

void render_image(vector<int> image) {
	int index = 0;
	for(int i = 0; i < HEIGHT; i++) {
		for(int j = 0; j < WIDTH; j++) {
			cout << (image[index] ? "X " : ". ");
			index++;
		}
		cout << endl;
	}
}


int main() {
    vector< vector<int> > layers = get_layers_from_input();
    vector<int> layer = get_layer_fewer_zeros(layers);

    // On the layer with fewer zeros, the  number of 1 digits multiplied by the number of 2 digits is :
    cout << "Part 1 : " << count_digits_in_layer(layer, 1) * count_digits_in_layer(layer, 2) << endl;

    vector<int> image = decode_image(layers);
    cout << "Part 2 : " << endl;
    render_image(image);

    return 0;
}
