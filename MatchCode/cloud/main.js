Parse.Cloud.define("findMatches", function(request, response) {

    var weights = function(music) {
        var sum = 0
        var weights = {}
        for (var artist in music.songCounts) {
            sum += music.soungCounts(artist)
        }
        for (var artist in music.songCounts) {
            weights[artist] = parseFloat(songCount)/sum
        }
        return weights
    }
    var common_elements = function(arr1, arr2) {
        var common= []
        for (var a1 in arr1) {
            for (var  a2 in arr2) {
                if (a1 == a2) {
                    common.push(a1)
                }
            }
        }
        return common
    }

    var musicScore = function(music1, music2) {
        var commonArtists = common_elements(music1.artists, music2.artists)
        var weights1 = weights(music1)
        var weights2 = weights(music2)
        var score1 = 0.0
        var score2 = 0.0
        for (var artist in commonArtists) {
            score1 += weights1[artist]
            score2 += weights2[artist]
        }
        var score = Math.min(score1, score2)
        var matchScore = Math.min(parseInt(Math.floor(score/0.06)),5)
        return matchScore
    }

    var matchScore = function(user1, user2) {
        var common_prefs = common_elements(user1.get("preferences"), user2.get("preferences"))
        if (common_prefs.length == 0) {
            return -1;
        }
        var music1 = JSON.parse(user1.get("music"))
        var music2 = JSON.parse(user2.get("music"))
        return musicScore(music1, music2)
    }

    var findMatches = function(user, potential_matches) {
        var matches = []
        var last_date = new Date(0)
        for (var potential_match in potential_matches){
            var score = matchScore(user, potential_match)
            if (score>0) {
                matches.push([potential_match.get("id"), score])
            }
            if (potential_match.get("createdAt") > last_date) {
                last_date = potential_match.get("createdAt")
            }
        }
        return [matches, last_date]
    }


    var email = request.params.email
    var query = new Parse.Query("User");
    query.equalTo("email", email)
    query.find({
        success: function(results) {
            var user = results[0]
            var lastTime = results[0].get("lastTimeMatched")
            var query = new Parse.Query("User");
            query.greaterThan("createdAt", lastTime)
            //***
            query.find({
                success: function(results) {
                    var output = findMatches(user, results)
                    var matches = output[0]
                    var last_date = output[1]
                    response.success(match)
                    user.set("lastTimeMatched", last_date)
                    user.save()
                },
                error: function() {
                    response.error("movie lookup failed")
                }
            });
            //***
        },
        error: function() {
            response.error("movie lookup failed");
        }
    
  });

});