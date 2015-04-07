Parse.Cloud.define("findMatches", function(request, response) {

    var weights = function(music) {
        var sum = 0
        var weights = {}
        for (var artist in music.songCounts) {
            sum += music.songCounts[artist]
        }
        for (var artist in music.songCounts) {
            weights[artist] = parseFloat(music.songCounts[artist])/sum
        }
        return weights
    }
    var common_elements = function(arr1, arr2) {
        var common= []

        for (var i=0; i<arr1.length; i++) {
            a1 = arr1[i]
            for (var  j=0; j<arr2.length; j++) {
                a2 = arr2[j]
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
        for (var i=0; i< commonArtists.length; i++) {
            artist = commonArtists[i]
            score1 += weights1[artist]
            score2 += weights2[artist]
        }
        var score = Math.max(score1, score2)
        var matchScore = Math.min(parseInt(Math.ceil(score/0.06)),5)
        return matchScore
    }

    var matchScore = function(user1, user2) {
        var common_prefs = common_elements(user1.get("preferences"), user2.get("preferences"))
        if (common_prefs.length == 0) {
            return -1;
        }
        var music1 = user1.get("music")
        var music2 = user2.get("music")
        return musicScore(music1, music2)
    }

    var findMatches = function(user, potential_matches) {
        var matches = []
        var last_date = new Date(0)
        for (var i=0; i<potential_matches.length; i++){
            var potential_match = potential_matches[i]
            var score = matchScore(user, potential_match)
            console.log(potential_match.createdAt)
            if (score>0 && potential_match.get("email")!=user.get("email")) {
                matches.push([potential_match.id, String(score)])
            }

            if (potential_match.createdAt > last_date) {
                last_date = potential_match.createdAt
            }
        }
        return [matches, last_date]
    }


    var email = request.params.email
    var echouser = Parse.Object.extend("EchoUser");
    var query = new Parse.Query(echouser);
    console.log(email)
    query.equalTo("email", email)
    query.find({
        success: function(results) {
            var user = results[0]
            var lastTime = results[0].get("lastTimeMatched")
            var echouser = Parse.Object.extend("EchoUser");
            var query = new Parse.Query(echouser);
            query.greaterThan("createdAt", lastTime)
            //***
            query.find({
                success: function(results) {
                    console.log(results)
                    var output = findMatches(user, results)
                    
                    var matches = output[0]
                    var last_date = output[1]
                    console.log(matches)
                    response.success(matches)
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