// /functions/handle-error.js

export async function onRequest(context) {
   const { request, env } = context;
   const url = new URL(request.url);

   // Padrão de status de erro
   let statusCode = 404; // Se nenhum erro for especificado, 404 é o padrão
   if (request.status === 500) {
      statusCode = 500;
   }

   // Página de erro padrão
   let errorPage = '404.html';  // Página de erro padrão 404
   if (statusCode === 500) {
      errorPage = '500.html';     // Página de erro 500
   }

   try {
      // Busca o arquivo de erro no diretório 'errors'
      const errorResponse = await env.ASSETS.fetch(`errors/${errorPage}`);
      return new Response(errorResponse.body, {
         status: statusCode,
         headers: {
            'Content-Type': 'text/html; charset=utf-8',
         },
      });
   } catch (e) {
      // Caso não encontre o arquivo de erro, retorna uma mensagem genérica
      return new Response('Página de erro não encontrada.', {
         status: 500,
         headers: {
            'Content-Type': 'text/plain; charset=utf-8',
         },
      });
   }
}
