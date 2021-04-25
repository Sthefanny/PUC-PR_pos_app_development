using UnityEngine;

public class GameManager : MonoBehaviour
{
    public int points = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void AddPoints(int pointsToAdd) {
        points += pointsToAdd;
    }
}
