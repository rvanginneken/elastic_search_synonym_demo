<?php

namespace App\Controller;

use App\Core\Service\Elastic;
use Elasticsearch\ClientBuilder;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class SearchController extends AbstractController
{
    /**
     * @Route("/search", name="app.search")
     */
    public function index(Request $request): Response
    {
        $client = ClientBuilder::create()->build();

        $params = [
            'index' => 'movies',
            'body' => [
                'from' => 0,
                'size' => 50,
            ]
        ];

        $keywords = $request->query->get('keywords', '');
        if (!empty($keywords)) {
            $params['body']['query']['bool']['must']['match']['title'] = [
                'query' => $keywords,
                'fuzziness' => 'AUTO',
                'operator' => 'OR',
            ];
        }

        $result = $client->search($params);

        return $this->render('search.html.twig', [
            'count' => $result['hits']['total']['value'],
            'movies' => array_map(static function(array $hit) {
                return $hit['_source'];
            }, $result['hits']['hits']),
        ]);
    }
}
