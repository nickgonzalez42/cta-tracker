<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/nickgonzalez42/cta-tracker">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Chicago_Transit_Authority_Logo.svg/1200px-Chicago_Transit_Authority_Logo.svg.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">CTA Tracker</h3>

  <p align="center">
    Track CTA Trains and Buses in the terminal
    <br />
    <a href="https://github.com/nickgonzalez42/cta-tracker"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/nickgonzalez42/cta-tracker">View Demo</a>
    ·
    <a href="https://github.com/nickgonzalez42/cta-tracker/issues">Report Bug</a>
    ·
    <a href="https://github.com/nickgonzalez42/cta-tracker/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://user-images.githubusercontent.com/41881164/219143471-22e024d7-cbc0-40f9-8368-00e00acaa962.png)

The intention of this project was to create a stripped down Chicago Transit Authority (CTA) train and bus tracker that can be run for your terminal. In it's current state, the app will display all schedued trains for a particular station and buses for a particular route going in a cardinal direction for a selected stop. After receiving the time predictions, the user can request service alerts for any lines that could impact their transit. More updates are planned to make the final version more user friendly.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

Setting up the program is as straight-forward as installing Ruby and downloading the gems in the gemfile.

### Prerequisites

The only prerequisite for running this program is to have Ruby installed on your machine: [https://www.ruby-lang.org/en/documentation/installation/](https://www.ruby-lang.org/en/documentation/installation/).
  ```sh
  brew install ruby
  ```

### Installation

1. Get a free API Keys at [https://www.transitchicago.com/developers/](https://www.transitchicago.com/developers/)
2. Clone the repo
   ```sh
   git clone https://github.com/nickgonzalez42/cta-tracker.git
   ```
3. Install Gem files
   ```sh
   bundle
   ```
4. Enter your APIs in `main.rb`
   ```rb
   train_key = "ENTER YOUR TRAIN API"
   bus_key = "ENTER YOUR BUS API"
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

1. Run main.rb to start the program (make sure to enter your API keys at the top of the file!)
2. On startup, the user is prompted for train or bus responses.
  <img width="263" alt="image" src="https://user-images.githubusercontent.com/41881164/219175220-7c4ab861-5598-40be-8c91-5a6eec4bd920.png">
3. If the user selects trains, the terminal will display an exhaustive list of CTA stations. The user can enter either the station code or the (case-sensitive) station name. 
  <img width="388" alt="image" src="https://user-images.githubusercontent.com/41881164/219179411-ed7abd79-1ad2-42a8-8bac-038d46669619.png">
<br />
4. The terminal will then display all (if any) trains are scheduled for that stop. 
  <img width="436" alt="image" src="https://user-images.githubusercontent.com/41881164/219180281-46172b84-37a7-4160-816d-9353c8fb6436.png">
<br />
5. The bus selection works similarly, however, the user will need to first select their bus route, direction, and then stop before seeing results. 
  <img width="316" alt="image" src="https://user-images.githubusercontent.com/41881164/219181149-fcd9a6e3-c28e-4b86-90e5-0cda35cb5f99.png">
  <img width="369" alt="image" src="https://user-images.githubusercontent.com/41881164/219181349-53251485-9d32-4d7c-85ed-fa16ed457be3.png">
  <img width="323" alt="image" src="https://user-images.githubusercontent.com/41881164/219181710-6ce36b40-5747-4239-864f-cdd78da5ab94.png">
  <img width="336" alt="image" src="https://user-images.githubusercontent.com/41881164/219182043-0b5e8ed4-d6bc-4ff4-9615-b6a1a668cb09.png">
<br />
6. After the predictions have been displayed, the user will be prompted if they'd like to view any alerts. <br />
  <img width="564" alt="image" src="https://user-images.githubusercontent.com/41881164/219180781-251f779a-f62b-4de1-a443-e1bfeca9d34d.png">

<p align="right">(<a href="#readme-top">back to top</a>)</p>




<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Nicholas Gonzalez - thisnickg194@gmail.com

Project Link: [https://github.com/nickgonzalez42/cta-tracker](https://github.com/nickgonzalez42/cta-tracker)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/nickgonzalez42/cta-tracker.svg?style=for-the-badge
[contributors-url]: https://github.com/nickgonzalez42/cta-tracker/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/nickgonzalez42/cta-tracker.svg?style=for-the-badge
[forks-url]: https://github.com/nickgonzalez42/cta-tracker/network/members
[stars-shield]: https://img.shields.io/github/stars/nickgonzalez42/cta-tracker.svg?style=for-the-badge
[stars-url]: https://github.com/nickgonzalez42/cta-tracker/stargazers
[issues-shield]: https://img.shields.io/github/issues/nickgonzalez42/cta-tracker.svg?style=for-the-badge
[issues-url]: https://github.com/nickgonzalez42/cta-tracker/issues
[license-shield]: https://img.shields.io/github/license/nickgonzalez42/cta-tracker.svg?style=for-the-badge
[license-url]: https://github.com/nickgonzalez42/cta-tracker/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/nicholasjgonzalez/
[product-screenshot]: https://user-images.githubusercontent.com/41881164/228363472-4adfcea1-4d67-4710-99d6-6e5cfe83089c.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
