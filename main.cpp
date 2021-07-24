#include <SFML/Graphics.hpp>
#include "mpreal.h"

#include <iostream>

#define DEFAULT_WINDOWS_SIZE 800
#define DEFAULT_PRECISION 8
#define DEFAULT_NUM_OF_POINTS 1024

unsigned int get_numeric_input(unsigned int default_value);

int main()
{
	unsigned int window_size = DEFAULT_WINDOWS_SIZE;

	std::cout << "Precision: ";
	unsigned int digits = get_numeric_input(DEFAULT_PRECISION);

	std::cout << "Number of points: ";
	unsigned int number_of_points
		= get_numeric_input(DEFAULT_NUM_OF_POINTS);

	mpfr::mpreal::set_default_prec(mpfr::digits2bits(digits));

	sf::ContextSettings settings;
	settings.antialiasingLevel = 16;
	sf::RenderWindow app(sf::VideoMode(window_size, window_size), "MC",
			sf::Style::Titlebar | sf::Style::Close, settings);

	float radius = window_size/2.0f;

	sf::RectangleShape rectangle;
	rectangle.setSize(sf::Vector2f(1, 1));

	sf::CircleShape ring(radius - 1.f);
	ring.setPosition(1.f, 1.f);
	ring.setPointCount(1000);
	ring.setFillColor(sf::Color::Black);
	ring.setOutlineColor(sf::Color::White);
	ring.setOutlineThickness(1.f);
	app.draw(ring);

	std::cout.precision(digits);

	mpfr::mpreal x, y;
	float screen_x, screen_y;
	mpfr::mpreal distance;
	unsigned int in_points = 0;
	unsigned int out_points = 0;
	bool result_printed = false;
	while (app.isOpen())
	{
		sf::Event event;
		while (app.pollEvent(event))
		{
			if (event.type == sf::Event::Closed) app.close();
		}
		if (number_of_points > 0)
		{
			x = mpfr::random();
			y = mpfr::random();
			distance = mpfr::pow(x - 0.5, 2) + mpfr::pow(y - 0.5, 2);
			screen_x = (x * window_size).toFloat();
			screen_y = (y * window_size).toFloat();
			rectangle.setPosition(screen_x, screen_y);
			if (distance > 0.25f)
			{
				++out_points;
				rectangle.setFillColor(sf::Color::Red);
			}
			else
			{
				++in_points;
				rectangle.setFillColor(sf::Color::Green);
			}
			--number_of_points;
			app.draw(rectangle);
		}
		else if (number_of_points == 0 && result_printed == false)
		{
			std::cout << "----------------------" << std::endl;
			std::cout << "In: " << in_points << std::endl;
			std::cout << "Out: " << out_points << std::endl;
			mpfr::mpreal sum = in_points + out_points;
			std::cout << "Pi: " << 4.f*in_points / sum << std::endl;
			result_printed = true;
		}
		app.display();
	}

	return 0;
}

unsigned int get_numeric_input(unsigned int default_value)
{
	unsigned int temp;
	if (!(std::cin >> temp))
	{
		std::cin.clear();
		std::cin.ignore(std::numeric_limits<std::streamsize>::max(),
				'\n');
		return default_value;
	}
	return temp;
}
