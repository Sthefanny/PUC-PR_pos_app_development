using UnityEngine;

namespace Assets.Scripts
{
    public class CoinRotate : MonoBehaviour
    {

        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
            transform.Rotate(0.2f, 0, 0.01f);
        }
    }
}