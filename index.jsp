<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="stylesheet" href="style.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
  <title>Jobify</title>
  <style>
    #suggestions {
      width: 400px;
      border: 1px solid #ccc;
      max-height: 150px;
      overflow-y: auto;
      position: absolute;
      background: #fff;
      z-index: 999;
      font-size: 16px;
    }

    #suggestions div {
      padding: 8px;
      cursor: pointer;
    }

    #suggestions div:hover {
      background-color: #f0f0f0;
    }
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar">
    <div class="navdiv">
      <div class="logo">
        <img src="img1.jpg">
      </div>
      <div>
        <button id="btn1"><a href="login.jsp">Login</a></button>
        <button id="btn2"><a href="register.jsp">Sign Up</a></button>
      </div>
    </div>
  </nav>

  <!-- Hero Section -->
  <div class="search-container">
    <div class="text">
      <h1 id="heading">Make your dream come true with Jobify.</h1>
      <h3 id="sheading">Build your future with us.</h3>
    </div>
    <div class="searchbar">
      <form action="searchJobs.jsp" method="get" autocomplete="off">
        <input type="text" id="searchInput" name="query" placeholder="Enter job title, company or location" style="width: 400px; height: 35px; font-size: 16px; padding: 5px;" required />
        <button id="sbt" type="submit" style="height: 45px; font-size: 16px;"><i class="fa fa-search"></i></button>
        <div id="suggestions"></div>
      </form>
    </div>
  </div>

  <!-- Introduction Section -->
  <div class="content">
    <div class="main-section">
      <div class="content-left">
        <p class="section-label">VERY PROUD TO INTRODUCE</p>
        <h1 class="section-title">Your Career Starts Here</h1>
        <p class="section-description">
          At Jobify, we connect employers with potential candidates and help individuals land their dream jobs with ease. Whether you're hiring or looking for the next big opportunity — you're in the right place.
        </p>
        <div class="button-group">
          <a href="register.jsp" class="btn-get-started">Get Started</a>
        </div>
      </div>
      <div class="content-right">
        <div class="img-container">
          <img src="img2.jpg" alt="Job Search Team" />
        </div>
      </div>
    </div>
  </div>

  <!-- 3 Card Section -->
  <section class="card-section">
    <h2 class="card-title">Why Choose Jobify?</h2>
    <div class="card-container">
      <div class="card">
        <i class="fas fa-briefcase"></i>
        <h3>Top Companies</h3>
        <p>Connect with leading employers actively hiring talent like you.</p>
      </div>
      <div class="card">
        <i class="fas fa-chart-line"></i>
        <h3>Career Growth</h3>
        <p>Find jobs that match your skills, passion, and career goals.</p>
      </div>
      <div class="card">
        <i class="fas fa-user-check"></i>
        <h3>Verified Applicants</h3>
        <p>Employers receive quality candidates verified through our platform.</p>
      </div>
    </div>
  </section>

  <script>
    const searchInput = document.getElementById("searchInput");
    const suggestionsDiv = document.getElementById("suggestions");

    searchInput.addEventListener("input", () => {
      const query = searchInput.value.trim();
      if (query.length > 1) {
        fetch("GeminiSuggestServlet?query=" + encodeURIComponent(query))
          .then(response => response.json())
          .then(data => {
            suggestionsDiv.innerHTML = "";
            data.suggestions.forEach(suggestion => {
              const div = document.createElement("div");
              div.textContent = suggestion;
              div.addEventListener("click", () => {
                searchInput.value = suggestion;
                suggestionsDiv.innerHTML = "";
              });
              suggestionsDiv.appendChild(div);
            });
          });
      } else {
        suggestionsDiv.innerHTML = "";
      }
    });
  </script>
</body>
</html>
